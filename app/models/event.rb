class Event < ActiveRecord::Base
  belongs_to :mechanic

  validates :date_start, :mechanic, presence: true
  validate :is_event_unique_for_mechanic, if: :mechanic

  scope :weekly, -> { where(recurrence: :weekly) }

  def as_json(options = {})
    { start: date_start, title: title, url: mechanics_event_path(self), id: id }
  end

  def is_event_unique_for_mechanic
    self.errors.add(:date_start, "Is not unique") unless EventsManager.new(self.mechanic).check_date(date_start)
  end
end
