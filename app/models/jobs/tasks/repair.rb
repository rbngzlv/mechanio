class Repair < Task

  has_and_belongs_to_many :symptoms, foreign_key: :task_id

  validates :title, presence: true
end
