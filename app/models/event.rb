class Event < ActiveRecord::Base
  belongs_to :mechanic
  belongs_to :job, inverse_of: :event

  serialize :schedule, IceCube::Schedule

  validates :start_time, :end_time, :mechanic, presence: true 
  validates :count, numericality: { greater_than: 0 }, allow_blank: true
  validates :recurrence, inclusion: { in: ['daily', 'weekly', 'monthly'] }, allow_blank: true
  validate :verify_end_time

  before_create :build_schedule
  before_save :set_title


  def set_title
    self.title = case
      when recurrence then "#{recurrence} from #{start_date_short}, #{time_range}"
      else time_range
    end
  end

  def is_appointment?
    job.present?
  end

  def time_range
    start_hour = start_time.to_s(:hour).strip
    end_hour   = end_time.to_s(:hour).strip
    "#{start_hour} - #{end_hour}"
  end

  def start_date_short
    start_time.strftime('%-d %b')
  end

  def add_exception_time(time)
    schedule.add_exception_time(time)
  end

  def build_schedule
    schedule = IceCube::Schedule.new(start_time, end_time: end_time)

    if recurrence
      rule = IceCube::Rule.send(recurrence)
      rule = rule.count(count)        if count
      rule = rule.until(occurs_until) if occurs_until
      schedule.add_recurrence_rule(rule)
    end

    self.schedule = schedule
  end


  private

  def verify_end_time
    valid = start_time.present? && end_time.present? && start_time < end_time
    errors.add(:end_time, 'should be after start date') unless valid
  end
end
