class Part < ActiveRecord::Base

  has_one :task_item, as: :itemable

  validates :name, :cost, :quantity, presence: true
end
