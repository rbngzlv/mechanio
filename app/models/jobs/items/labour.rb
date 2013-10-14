class Labour < ActiveRecord::Base

  has_one :task_item, as: :itemable

  validates :description, :duration, :hourly_rate, presence: true

  after_validation :set_cost

  def display_duration
    Time.at(duration * 60).utc.strftime("%H:%M")
  end

  def set_cost
    self.cost = duration * hourly_rate / 60 if duration
  end
end
