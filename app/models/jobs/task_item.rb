class TaskItem < ActiveRecord::Base

  belongs_to :task
  belongs_to :itemable, polymorphic: true

  delegate :cost, to: :itemable
end
