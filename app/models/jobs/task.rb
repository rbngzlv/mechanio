class Task < ActiveRecord::Base

  belongs_to :job
  has_many :task_items

  accepts_nested_attributes_for :task_items, allow_destroy: true, reject_if: proc { |attrs| attrs[:itemable_attributes].all? { |k, v| v.blank? } }

  after_save :set_cost

  default_scope { order(:created_at) }

  def set_cost
    costs = task_items.map(&:cost)
    cost = costs.include?(nil) ? nil : costs.sum
    cost = nil if cost == 0
    update_column(:cost, cost)
  end
end
