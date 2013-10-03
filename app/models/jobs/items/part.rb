class Part < ActiveRecord::Base

  belongs_to :task

  validates :task, :name, :cost, :quantity, presence: true
end
