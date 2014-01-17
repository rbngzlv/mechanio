class Labour < ActiveRecord::Base

  HOURS = (0..10)
  MINUTES = [0, 30]
  HOURLY_RATE = 50 #FIXME: hourly rate should probably be fetched from site settings or something

  has_one :task_item, as: :itemable

  validates :duration_hours, presence: true
  validates :duration_hours, inclusion: { in: Labour::HOURS }
  validates :duration_minutes, inclusion: { in: Labour::MINUTES }

  after_validation :set_cost

  after_initialize do
    self.duration_hours   ||= 0
    self.duration_minutes ||= 0
    self.hourly_rate      ||= HOURLY_RATE
  end

  def self.hour_options
    HOURS.map { |h| sprintf('%02d h', h) }.zip(HOURS)
  end

  def self.minute_options
    MINUTES.map { |m| sprintf('%02d m', m) }.zip(MINUTES)
  end

  def duration
    duration_hours.to_i * 60 + duration_minutes.to_i
  end

  def display_duration
    Time.at(duration * 60).utc.strftime("%-H:%M")
  end

  def set_cost
    self.cost = duration * hourly_rate / 60
  end
end
