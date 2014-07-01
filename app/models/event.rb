class Event < ActiveRecord::Base
  belongs_to :mechanic
  belongs_to :job, inverse_of: :event

  serialize :schedule

  validates :date_start, :time_start, :time_end, :mechanic, presence: true
  validates :count, numericality: { greater_than: 0 }, allow_blank: true
  validates :recurrence, inclusion: { in: ['daily', 'weekly', 'monthly'] }, allow_blank: true
  validate :verify_end_date, if: :date_end
  # validate :verify_event_overlap, if: :mechanic

  scope :repeated, ->(rec) { where(recurrence: rec) }
  scope :time_slot, ->(start) { where(time_start: start) }

  before_validation :set_title

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

  def date_start_short
    date_start.strftime('%-d %b')
  end

  def schedule
    IceCube::Schedule.from_hash(read_attribute(:schedule))
  end

  private

  def verify_event_overlap
    self.errors.add(:date_start, 'there is another event on this date') unless EventsManager.new(self.mechanic).check_uniqueness(self)
  end

  def verify_end_date
    errors.add(:date_end, 'should be after start date') if date_end <= date_start
  end
end
