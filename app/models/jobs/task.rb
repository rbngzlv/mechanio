class Task < ActiveRecord::Base

  belongs_to :job
  has_many :task_items

  def set_cost
    self.cost = task_items.map(&:cost).sum
  end
end
