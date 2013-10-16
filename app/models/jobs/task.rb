class Task < ActiveRecord::Base

  belongs_to :job
  has_many :task_items

  accepts_nested_attributes_for :task_items, reject_if: proc { |attrs| attrs[:itemable_attributes].all? { |k, v| v.blank? } }

  default_scope { order(:created_at) }

  def set_cost
    costs = task_items.map(&:cost)
    self.cost = costs.include?(nil) ? nil : costs.sum
    self.cost = nil if self.cost == 0
  end
end
