class Job < ActiveRecord::Base

  STATUSES = %w(pending estimated assigned payment_error awaiting_feedback completed cancelled)

  belongs_to :user
  belongs_to :car
  belongs_to :location, dependent: :destroy
  belongs_to :mechanic
  belongs_to :credit_card
  belongs_to :discount
  has_many :tasks, inverse_of: :job, dependent: :destroy
  has_one :appointment, dependent: :destroy
  has_one :event, dependent: :destroy
  has_one :payout
  has_one :rating

  accepts_nested_attributes_for :car, :location, update_only: true
  accepts_nested_attributes_for :tasks, allow_destroy: true, reject_if: proc { |attrs| attrs.all? { |k, v| k == 'type' || v.blank? } }

  serialize :serialized_params

  before_validation :assign_car_to_user
  before_create :set_uid
  before_save :set_title

  validates :car, :location, :tasks, :contact_email, :contact_phone, presence: true
  validates :contact_phone, phone: true
  validates :user, presence: true, unless: :skip_user_validation
  validates :cost, numericality: { greater_than: 0 }, allow_blank: true

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
    end
    state :assigned do
      transition to: :cancelled, on: :cancel
      transition to: :completed, on: :complete
      transition to: :payment_error, on: :payment_error
      validates :mechanic, :scheduled_at, :assigned_at, :credit_card, :appointment, presence: true
    end
    state :payment_error
    state :awaiting_feedback
    state :completed do
      # validates :transaction_id, presence: true
    end
    state :cancelled
  end

  default_scope { order(created_at: :desc).without_status(:temporary) }

  scope :estimated, -> { with_status(:estimated).reorder(created_at: :desc) }
  scope :assigned,  -> { with_status(:assigned).reorder(scheduled_at: :desc) }
  scope :completed, -> { with_status(:completed).reorder(scheduled_at: :desc) }
  scope :unrated,   -> { completed.includes(:rating).where('ratings.id' => nil) }
  scope :paid,      -> { includes(:payout).where.not(payouts: { id: nil }) }


  def self.find_temporary(id)
    unscoped.with_status(:temporary).find(id)
  end

  def self.get_location_from_temporary(id)
    job = find_temporary(id) rescue nil
    job.serialized_params[:job][:location_attributes] if job
  end

  def has_service?
    tasks.any? { |t| t.is_a?(Service) }
  end

  def has_repair?
    tasks.any? { |t| t.is_a?(Repair) }
  end

  def has_inspection?
    tasks.any? { |t| t.is_a?(Inspection) }
  end

  def car_attributes=(attrs)
    self.car = Car.find(attrs[:id]) if attrs[:id].present?
    super
  end

  def client_name
    user ? user.full_name : '-'
  end

  def assign_car_to_user
    car.user_id = user_id if car && user_id
  end

  def set_title
    title = []
    service = tasks.find { |t| t.is_a?(Service) }
    title << service.set_title if service
    title << 'repair'     if has_repair?
    title << 'inspection' if has_inspection?

    self.title = title.to_sentence.capitalize
  end

  def set_uid
    self.uid = rand(36**10).to_s(36).upcase
  end

  def set_cost
    cost_calculator = CostCalculator.new(self)
    cost_calculator.set_job_cost
  end

  def quote_available?
    cost && cost > 0
  end

  def quote_changed?
    !cost_was.nil? && cost_changed?
  end

  def rated?
    rating.present? && rating.published
  end

  def can_be_completed?
    completed_at.nil? && scheduled_at.present? && scheduled_at < Time.now
  end

  def as_json(options = {})
    if options[:format] == :list
      super(only: [:id, :scheduled_at, :title], include: {
        user: { only: [], methods: [:full_name] },
        car: { only: [:display_title] },
        location: { only: [:address, :suburb, :postcode], methods: [:state_name] }
      })
    else
      super(only: [:id, :discount_amount, :final_cost, :contact_phone], include: {
        user: { only: [], methods: [:full_name, :avatar_thumb] },
        car: { only: [:display_title, :vin, :reg_number] },
        location: { only: [:address, :suburb, :postcode], methods: [:state_name] },
        tasks: { only: [:id, :title, :note, :type, :cost, :service_plan_id], include: {
          task_items: { only: [:id, :itemable_id, :itemable_type], include: {
            itemable: { only: [:id, :description, :cost, :hourly_rate, :duration_hours, :duration_minutes, :name, :quantity, :unit_cost] }
          }}
        }},
        discount: { only: [:title, :code, :discount_type, :discount_value ] }
      })
    end
  end
end
