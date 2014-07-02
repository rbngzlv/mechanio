class Event < ActiveRecord::Base
  belongs_to :mechanic
  belongs_to :job, inverse_of: :event

  serialize :schedule

  validates :date_start, :time_start, :time_end, :mechanic, presence: true
  validates :count, numericality: { greater_than: 0 }, allow_blank: true
  validates :recurrence, inclusion: { in: ['daily', 'weekly', 'monthly'] }, allow_blank: true
  validate :verify_end_date, if: :date_end
  # validate :verify_event_overlap, if: :mechanic

  scope :repeated,  ->(rec)   { where(recurrence: rec) }
  scope :time_slot, ->(start) { where(time_start: start) }

  before_validation :set_title
  before_save :build_schedule

  def set_title
    self.title = case
      when recurrence then "#{recurrence} from #{date_start_short}, #{time_range}"
      else time_range
    end
  end

  def is_appointment?
    job.present?
  end

  def time_range
    start_hour = time_start.to_s(:hour).strip if time_start
    end_hour   = time_end.to_s(:hour).strip if time_end
    "#{start_hour} - #{end_hour}"
  end

  def start_date_time
    start = date_start.in_time_zone
    start = start.change(hour: time_start.hour, min: 0) if time_start
    start
  end

  def date_start_short
    date_start.strftime('%-d %b')
  end

  def schedule
    hash = read_attribute(:schedule)
    IceCube::Schedule.from_hash(hash) if hash
  end

  def build_schedule
    schedule = IceCube::Schedule.new(start_date_time)

    if recurrence
      rule = IceCube::Rule.send(recurrence)
      rule = rule.count(count)    if count
      rule = rule.until(date_end) if date_end
      schedule.add_recurrence_rule(rule)
    end

    self.schedule = schedule.to_hash
  end


  private

  def verify_event_overlap
    self.errors.add(:date_start, 'there is another event on this date') unless EventsManager.new(self.mechanic).check_uniqueness(self)
  end

  def verify_end_date
    errors.add(:date_end, 'should be after start date') if date_end <= date_start
  end
end
