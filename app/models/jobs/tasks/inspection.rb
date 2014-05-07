class Inspection < Task

  INSPECTION_COST = 80

  validates :title, :description, presence: true

  def task_items
    []
  end
end
