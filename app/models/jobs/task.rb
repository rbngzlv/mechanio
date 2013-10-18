class Task < ActiveRecord::Base

  belongs_to :job
  has_many :task_items

  accepts_nested_attributes_for :task_items, allow_destroy: true, reject_if: proc { |attrs| attrs[:itemable_attributes].all? { |k, v| v.blank? } }

  default_scope { order(:created_at) }

  def set_cost
    costs = task_items.map { |ti| ti.marked_for_destruction? ? 0 : ti.set_cost }
    self.cost = costs.include?(nil) ? nil : costs.sum
    self.cost = nil if self.cost == 0
    self.cost
  end
end
