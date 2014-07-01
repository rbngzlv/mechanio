class FixedAmount < ActiveRecord::Base

  has_one :task_item, as: :itemable

  validates :description, :cost, presence: true
  validates :cost, numericality: true

  def set_cost
  end

  def data
    [description, '', cost]
  end
end
