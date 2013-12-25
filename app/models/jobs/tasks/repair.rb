class Repair < Task

  has_and_belongs_to_many :symptoms, foreign_key: :task_id

  validates :title, presence: true
  validates :symptoms, presence: true, if: :note_empty?
  validates :note, presence: true, if: :symptoms_empty?


  def note_empty?
    note.try(:empty?)
  end

  def symptoms_empty?
    symptom_ids.try(:empty?)
  end
end
