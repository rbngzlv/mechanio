class Labour < ActiveRecord::Base

  HOURS = (1..10)
  MINUTES = [0, 30]

  has_one :task_item, as: :itemable

  validates :description, :duration_hours, :duration_minutes, :hourly_rate, presence: true
  validates :duration_hours, inclusion: { in: Labour::HOURS }
  validates :duration_minutes, inclusion: { in: Labour::MINUTES }

  # TODO: hourly rate should probably be fetched from site settings or something
  after_initialize do
    self.hourly_rate = 50
  end

  def duration
    duration_hours * 60 + duration_minutes rescue nil
  end

  def display_duration
    Time.at(duration * 60).utc.strftime("%-H:%M")
  end

  def set_cost
    self.cost = duration * hourly_rate / 60 if duration
  end
end
