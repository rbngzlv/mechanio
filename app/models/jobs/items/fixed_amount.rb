class FixedAmount < ActiveRecord::Base

  belongs_to :task

  validates :task, :description, :cost, presence: true
end
