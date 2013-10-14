class Part < ActiveRecord::Base

  has_one :task_item, as: :itemable

  validates :name, :unit_cost, :quantity, presence: true

  after_validation :set_cost

  def set_cost
    self.cost = unit_cost * quantity if unit_cost
  end
end
