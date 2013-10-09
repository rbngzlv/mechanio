class Labour < ActiveRecord::Base

  has_one :task_item, as: :itemable

  validates :description, :duration, :hourly_rate, presence: true
end
