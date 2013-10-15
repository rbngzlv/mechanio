class FixedAmount < ActiveRecord::Base

  has_one :task_item, as: :itemable

  validates :description, :cost, presence: true
  validates :cost, numericality: { greater_than: 0 }
end
