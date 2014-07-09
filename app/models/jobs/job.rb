class Job < ActiveRecord::Base

  STATUSES = %w(pending estimated assigned completed charged charge_failed paid_out rated cancelled)
  DELETE_REASONS = %w(already_done plan_in_future lower_quote other)

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
  before_save :set_search_terms

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
      transition to: :assigned,         on: :assign
      transition to: :estimate_deleted, on: :delete_estimate
    end
    state :estimate_deleted do
      validates :delete_reason, :estimate_deleted_at, presence: true
      validates :delete_reason_other, presence: true, if: :delete_reason_other?
    end
    state :assigned do
      transition to: :completed, on: :complete, if: :appointment_passed?
      validates :mechanic, :scheduled_at, :assigned_at, :credit_card, :appointment, :event, presence: true
    end
    state :completed do
      transition to: :charged, on: :charged
      transition to: :charge_failed, on: :charge_failed
    end
    state :charged do
      transition to: :paid_out, on: :paid_out
    end
    state :charge_failed
    state :paid_out
    state :cancelled

    event :cancel do
      transition [:temporary, :pending, :estimated, :assigned] => :cancelled
    end
  end

  default_scope { order(scheduled_at: :desc).without_status(:temporary) }

  scope :pending,       -> { with_status(:pending) }
  scope :estimated,     -> { with_status(:estimated).reorder(created_at: :desc) }
  scope :assigned,      -> { with_status(:assigned) }
  scope :completed,     -> { with_status(:completed) }
  scope :charged,       -> { with_status(:charged) }
  scope :charge_failed, -> { with_status(:charge_failed) }
  scope :paid_out,      -> { with_status(:paid_out) }
  scope :cancelled,     -> { with_status(:cancelled) }
  scope :past,          -> { with_status(:completed, :charged, :charge_failed, :paid_out) }
  scope :rated,         -> { past.includes(:rating).where.not(ratings: { id: nil }).references(:rating) }
  scope :unrated,       -> { past.includes(:rating).where(ratings: { id: nil }).references(:rating) }
  scope :search,        -> (query) { where("jobs.search_terms LIKE ?", "%#{query}%") }


  def past?
    ['completed', 'charged', 'charge_failed', 'paid_out'].include?(status)
  end

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
    Jobs::Calculate.new(self).call
  end

  def set_search_terms
    terms = [uid, contact_phone]
    terms << user.full_name if user.present?
    terms << [mechanic.full_name, mechanic.mobile_number] if mechanic.present?
    terms << location.full_address if location.present?

    self.search_terms = terms.flatten.compact.map(&:downcase).join(' ')
  end

  def quote_available?
    cost && cost > 0
  end

  def quote_changed?
    !cost_was.nil? && cost_changed?
  end

  def has_published_rating?
    rating.present? && rating.published
  end

  def appointment_passed?
    scheduled_at < Time.now
  end

  def delete_reason_other?
    delete_reason == 'other'
  end

  def as_json(options = {})
    if options[:format] == :list
      super(only: [:id, :scheduled_at, :title], include: {
        user: { only: [], methods: [:full_name] },
        car: { only: [:display_title] },
        location: { only: [:address], methods: [:suburb_name] }
      })
    else
      super(only: [:id, :discount_amount, :final_cost, :contact_phone], include: {
        user: { only: [], methods: [:full_name, :avatar_thumb] },
        car: { only: [:display_title, :vin, :reg_number] },
        location: { only: [:address], methods: [:suburb_name] },
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
