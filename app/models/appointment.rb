class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :mechanic
  belongs_to :job

  validates :user, :mechanic, :job, :scheduled_at, presence: true
end
