class ServiceCost < ActiveRecord::Base

  has_one :task_item, as: :itemable
  belongs_to :service_plan

  validates :description, :cost, :service_plan, presence: true
  validates :cost, numericality: { greater_than: 0 }

  def service_plan=(service_plan)
    super
    self.description = service_plan.display_title
    set_cost
  end

  def set_cost
    self.cost = service_plan.cost
  end
end
