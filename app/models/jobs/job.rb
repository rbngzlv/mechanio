class Job < ActiveRecord::Base

  belongs_to :user
  belongs_to :car
  belongs_to :mechanic
  belongs_to :location
  has_many :tasks, inverse_of: :job

  accepts_nested_attributes_for :car, :location, :tasks

  serialize :serialized_params

  before_validation :assign_car_to_user

  validates :user, :car, :location, :tasks, :contact_email, :contact_phone, presence: true

  def self.create_temporary(params)
    if Job.new(params).valid?
      job = Job.new(serialized_params: params)
      job.save(validate: false)
      job.id
    else
      false
    end
  end

  def assign_car_to_user
    car.user_id = user_id if car && user_id
  end
end
