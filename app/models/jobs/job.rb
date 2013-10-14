class Job < ActiveRecord::Base

  belongs_to :user
  belongs_to :car
  belongs_to :mechanic
  belongs_to :location
  has_many :tasks, inverse_of: :job

  accepts_nested_attributes_for :car, :location, :tasks

  serialize :serialized_params

  before_validation :assign_car_to_user
  before_save :set_title, :set_cost

  validates :car, :location, :tasks, :contact_email, :contact_phone, presence: true
  validates :user, presence: true, unless: :skip_user_validation

  attr_accessor :skip_user_validation

  state_machine :status, initial: :pending do
    state :temporary
    state :pending
    state :estimated
    state :assigned
    state :completed
  end

  default_scope { order(created_at: :desc).without_status(:temporary) }

  def self.create_temporary(params)
    job = build_temporary(params)
    unless job.valid?
      raise ActiveRecord::RecordInvalid, job
    end

    job = build_temporary(serialized_params: params)
    job.save(validate: false)
    job
  end

  def self.build_temporary(params)
    job = Job.new(params)
    job.status = :temporary
    job.skip_user_validation = true
    job.car.skip_user_validation = true if job.car
    job
  end

  def assign_car_to_user
    car.user_id = user_id if car && user_id
  end

  def date
    # TODO: It must return collection of time and date for event
    job_date ||= Time.now()
  end

  def set_title
    self.title = tasks.first.title if tasks.first
  end

  def set_cost
    costs = tasks.map(&:cost)
    self.cost = costs.include?(nil) ? nil : costs.sum
    self.cost = nil if self.cost == 0
  end

  def as_json(options = {})
    super(only: [:id, :cost], include: {
      car: { only: [:display_title] },
      tasks: { only: [:title] },
      location: { only: [:address, :suburb, :postcode], methods: [:state_name] }
    })
  end
end
