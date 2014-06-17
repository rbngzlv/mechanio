class Event < ActiveRecord::Base
  belongs_to :mechanic
  belongs_to :job, inverse_of: :event

  validates :date_start, :mechanic, presence: true
  validate :is_event_unique_for_mechanic, if: :mechanic

  scope :repeated, ->(rec) { where(recurrence: rec) }
  scope :time_slot, ->(start) { where(time_start: start) }

  before_validation :set_title

  def set_title
    self.title = case
      when recurrence then "#{recurrence} from #{date_start_short}, #{time_range}"
      else time_range
    end
  end

  def is_event_unique_for_mechanic
    self.errors.add(:date_start, "Is not unique") unless EventsManager.new(self.mechanic).check_uniqueness(self)
  end

  def is_appointment?
    job.present?
  end

  def time_range
    time_start ? "#{time_start.to_s(:time)} - #{time_end.to_s(:time)}" : "all day"
  end

  def date_start_short
    date_start.strftime('%-d %b')
  end
end
