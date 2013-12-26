class Job < ActiveRecord::Base

  belongs_to :user
  belongs_to :car
  belongs_to :mechanic
  belongs_to :location, dependent: :destroy
  has_many :tasks, inverse_of: :job, dependent: :destroy
  has_one :event, dependent: :destroy
  belongs_to :credit_card

  accepts_nested_attributes_for :car, :location, update_only: true
  accepts_nested_attributes_for :tasks, allow_destroy: true, reject_if: proc { |attrs| attrs.all? { |k, v| k == 'type' || v.blank? } }

  serialize :serialized_params

  before_validation :assign_car_to_user
  before_save :set_title, :set_cost, :set_status, :on_quote_change
  before_save :set_uid, unless: :uid

  validates :car, :location, :tasks, :contact_email, :contact_phone, presence: true
  validates :contact_phone, format: { with: /\A04\d{8}\z/ }
  validates :user, presence: true, unless: :skip_user_validation

  attr_accessor :skip_user_validation

  delegate :geocoded?, :postcode, to: :location, prefix: true, allow_nil: true

  state_machine :status, initial: :pending do
    state :temporary do
      transition to: :pending, on: :pending
      transition to: :estimated, on: :estimate
    end
    state :pending do
      transition to: :estimated, on: :estimate
    end
    state :estimated do
      transition to: :assigned,  on: :assign
      validates :cost, presence: true, numericality: { greater_than: 0 }
    end
    state :assigned do
      transition to: :confirmed, on: :confirm
      transition to: :cancelled, on: :cancel
      validates :mechanic, :scheduled_at, presence: true
      validate :scheduled_at_cannot_be_in_the_past, if: :scheduled_at
      validate :mechanic_available?, if: [:mechanic, :scheduled_at]
    end
    state :confirmed do
      transition to: :completed, on: :complete
      transition to: :payment_error, on: :payment_error
      validates :credit_card, presence: true
    end
    state :payment_error
    state :completed do
      validates :transaction_id, presence: true
    end

    after_transition to: :pending, do: :notify_pending
    after_transition from: [:temporary, :pending], to: :estimated, do: :notify_estimated
    after_transition from: :estimated, to: :assigned,  do: [:build_event_from_scheduled_at, :notify_assigned]

  end

  default_scope { order(created_at: :desc).without_status(:temporary) }

  scope :estimated, -> { with_status 'estimated' }
  scope :assigned,  -> { with_status 'assigned' }
  scope :completed, -> { with_status 'completed' }
  scope :upcoming,  -> { assigned.reorder(scheduled_at: :asc) }
  scope :past,      -> { completed.reorder(scheduled_at: :desc) }

  def self.sanitize_and_create(params)
    create(self.whitelist(params))
  end

  def self.create_temporary(params)
    job = build_temporary(self.whitelist(params))
    unless job.valid?
      raise ActiveRecord::RecordInvalid, job
    end

    job = build_temporary(serialized_params: params)
    job.save(validate: false)
    job
  end

  def self.build_temporary(params)
    job = Job.new(params)
    job.skip_user_validation = true
    job.car.skip_user_validation = true if job.car
    job.status = :temporary
    job
  end

  def self.convert_from_temporary(id, user)
    job = find_temporary(id)
    job.user_id = user.id
    job.update(self.whitelist(job.serialized_params))
    job
  end

  def self.find_temporary(id)
    unscoped.with_status(:temporary).find(id)
  end

  def self.get_location_from_temporary(id)
    job = find_temporary(id) rescue nil
    job.serialized_params[:job][:location_attributes] if job
  end

  def self.whitelist(params)
    params = ActionController::Parameters.new(params) unless params.is_a?(ActionController::Parameters)
    params.require(:job).permit(
      :car_id, :contact_email, :contact_phone,
      location_attributes:  [:address, :suburb, :postcode, :state_id],
      car_attributes:       [:id, :year, :model_variation_id, :last_service_kms, :last_service_date],
      tasks_attributes:     [:type, :service_plan_id, :note, :title, symptom_ids: [],
        task_items_attributes: [:itemable_type,
          itemable_attributes: [:description, :name, :unit_cost, :quantity, :duration_hours, :duration_minutes, :cost]
        ]
      ]
    )
  end

  def has_service?
    tasks.any? { |t| t.is_a?(Service) }
  end

  def assign_mechanic(params)
    mechanic = Mechanic.find(params[:mechanic_id])

    self.attributes = params.merge(
      assigned_at: DateTime.now,
      mechanic_id: mechanic.id
    )
    assign && save
  end

  def build_event_from_scheduled_at
    self.build_event(date_start: scheduled_at, time_start: scheduled_at, time_end: scheduled_at + 2.hour, mechanic: mechanic).save
  end

  def car_attributes=(attrs)
    self.car = Car.find(attrs[:id]) if attrs[:id].present?
    super
  end

  def assign_car_to_user
    car.user_id = user_id if car && user_id
  end

  def set_title
    self.title ||= tasks.first.title if tasks.first
  end

  def set_uid
    return unless user

    first_name_part = user.first_name[0..2].ljust(3, 'X').upcase
    last_name_part = user.last_name[0..1].ljust(2, 'X').upcase
    date_time_part = DateTime.now.strftime("%d%m%H%M")

    self.uid = "#{first_name_part}#{last_name_part}#{date_time_part}"
  end

  def set_cost
    costs = tasks.map { |t| t.marked_for_destruction? ? 0 : t.set_cost }
    self.cost = costs.include?(nil) ? nil : costs.sum
    self.cost = nil if self.cost == 0
  end

  def set_status
    estimate if pending? && quote_available?

    if temporary? && !new_record?
      quote_available? ? estimate : pending
    end
  end

  def quote_available?
    cost && cost > 0
  end

  def quote_changed?
    !cost_was.nil? && cost_changed?
  end

  def scheduled_at_cannot_be_in_the_past
    errors.add(:scheduled_at, "You could not check time slot in the past") if
      scheduled_at < DateTime.now
  end

  def mechanic_available?
    self.errors.add(:scheduled_at, "This mechanic is unavailable in #{scheduled_at}") if EventsManager.new(mechanic).unavailable_at? scheduled_at
  end

  def on_quote_change
    if estimated? || assigned?
      notify_quote_changed if quote_changed?
    end
  end

  def as_json(options = {})
    if options[:format] == :list
      super(only: [:id, :scheduled_at, :title], include: {
        user: { only: [], methods: [:full_name] },
        car: { only: [:display_title] },
        location: { only: [:address, :suburb, :postcode], methods: [:state_name] }
      })
    else
      super(only: [:id, :cost, :contact_phone], include: {
        user: { only: [], methods: [:full_name, :avatar_thumb] },
        car: { only: [:display_title, :vin, :reg_number] },
        location: { only: [:address, :suburb, :postcode], methods: [:state_name] },
        tasks: { only: [:id, :title, :note, :type, :cost, :service_plan_id], include: {
          task_items: { only: [:id, :itemable_id, :itemable_type], include: {
            itemable: { only: [:id, :description, :cost, :hourly_rate, :duration_hours, :duration_minutes, :name, :quantity, :unit_cost] }
          }}
        }}
      })
    end
  end

  private

  def notify_pending
    AdminMailer.job_pending(self.id).deliver
    UserMailer.job_pending(self.id).deliver
  end

  def notify_estimated
    AdminMailer.job_estimated(self.id).deliver
    UserMailer.job_estimated(self.id).deliver
  end

  def notify_assigned
    AdminMailer.job_assigned(self.id).deliver
    UserMailer.job_assigned(self.id).deliver
    MechanicMailer.job_assigned(self.id).deliver
  end

  def notify_quote_changed
    AdminMailer.job_quote_changed(self.id).deliver
    UserMailer.job_quote_changed(self.id).deliver
  end
end
