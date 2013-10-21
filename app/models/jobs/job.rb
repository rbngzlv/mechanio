class Job < ActiveRecord::Base

  belongs_to :user
  belongs_to :car
  belongs_to :mechanic
  belongs_to :location
  has_many :tasks, inverse_of: :job

  accepts_nested_attributes_for :car, :location
  accepts_nested_attributes_for :tasks, allow_destroy: true, reject_if: proc { |attrs| attrs.all? { |k, v| k == 'type' || v.blank? } }

  serialize :serialized_params

  before_validation :assign_car_to_user
  before_save :set_title, :set_cost, :set_status

  validates :car, :location, :tasks, :contact_email, :contact_phone, presence: true
  validates :user, presence: true, unless: :skip_user_validation
  validates :mechanic, :scheduled_at, presence: true, if: Proc.new { |f| f.status == :assigned }

  attr_accessor :skip_user_validation

  state_machine :status, initial: :pending do
    state :temporary do
      transition to: :pending, on: :convert_from_temporary
    end
    state :pending do
      transition to: :estimated, on: :estimate
    end
    state :estimated do
      transition to: :assigned, on: :assign
      validates :cost, presence: true, numericality: { greater_than: 0 }
    end
    state :assigned
    state :completed

    after_transition all => :pending, :do => :send_new_job_email

    event :pending do
      transition all => :pending
    end
  end

  default_scope { order(created_at: :desc).without_status(:temporary) }

  def self.sanitize_and_create(params)
    create! self.whitelist(params)
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
    job.status = 'temporary'
    job.skip_user_validation = true
    job.car.skip_user_validation = true if job.car
    job
  end

  def self.convert_from_temporary(id, user)
    job = unscoped.with_status(:temporary).find(id)
    job.status = 'pending'
    job.user_id = user.id

    job.update_attributes!(self.whitelist(job.serialized_params))
    job
  end

  def self.whitelist(params)
    params = ActionController::Parameters.new(params) unless params.is_a?(ActionController::Parameters)
    params.require(:job).permit(
      :car_id, :contact_email, :contact_phone,
      location_attributes:  [:address, :suburb, :postcode, :state_id],
      car_attributes:       [:year, :model_variation_id],
      tasks_attributes:     [:type, :service_plan_id, :note, :title,
        task_items_attributes: [:itemable_type,
          itemable_attributes: [:description, :name, :unit_cost, :quantity, :duration_hours, :duration_minutes, :cost]
        ]
      ]
    )
  end

  def self.estimated
    with_status 'estimated'
  end

  def has_service?
    tasks.any? { |t| t.is_a?(Service) }
  end

  def assign_mechanic(params)
    Mechanic.find(params[:mechanic_id])
    params[:status] = :assigned
    params[:assigned_at] = DateTime.now
    update_attributes params
  end

  def assign_car_to_user
    car.user_id = user_id if car && user_id
  end

  def set_title
    self.title ||= tasks.first.title if tasks.first
  end

  def set_cost
    costs = tasks.map { |t| t.marked_for_destruction? ? 0 : t.set_cost }
    self.cost = costs.include?(nil) ? nil : costs.sum
    self.cost = nil if self.cost == 0
  end

  def set_status
    self.status = 'estimated' if pending? && cost && cost > 0
  end

  def as_json(options = {})
    super(only: [:id, :cost], include: {
      car: { only: [:display_title] },
      location: { only: [:address, :suburb, :postcode], methods: [:state_name] },
      tasks: { only: [:id, :title, :note, :type, :cost, :service_plan_id], include: {
        task_items: { only: [:id, :itemable_id, :itemable_type], include: {
          itemable: { only: [:id, :description, :cost, :hourly_rate, :duration_hours, :duration_minutes, :name, :quantity, :unit_cost] }
        }}
      }}
    })
  end

  private

  def send_new_job_email
    AdminMailer.new_job(self).deliver
  end
end
