class Part < ActiveRecord::Base

  has_one :task_item, as: :itemable

  validates :name, :unit_cost, :quantity, presence: true
  validates :unit_cost, numericality: { greater_than: 0 }
  validates :quantity, numericality: { greater_than: 0, only_integer: true }

  def set_cost
    self.cost = unit_cost * quantity if unit_cost
  end
end
