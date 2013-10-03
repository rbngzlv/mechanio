class Labour < ActiveRecord::Base

  belongs_to :task

  validates :task, :description, :duration, :hourly_rate, presence: true
end
