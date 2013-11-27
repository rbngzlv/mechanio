class Event < ActiveRecord::Base
  belongs_to :mechanic
  belongs_to :job

  validates :date_start, :mechanic, presence: true
  validate :is_event_unique_for_mechanic, if: :mechanic

  scope :repeated, ->(rec) { where(recurrence: rec) }
  scope :time_slot, ->(start) { where(time_start: start) }

  before_validation :set_title

  def set_title
    self.title = case
      when recurrence then "#{recurrence} from #{(time_start ? time_range_string : "#{date_start.to_s(:short)} for all day event")}"
      when time_start then time_range_string
      else "whole day"
    end
  end

  def is_event_unique_for_mechanic
    self.errors.add(:date_start, "Is not unique") unless EventsManager.new(self.mechanic).check_uniqueness(self)
  end

  private
  def time_range_string
    "#{time_start.to_s(:short)} - #{time_end.strftime('%H:%M')}"
  end
end
