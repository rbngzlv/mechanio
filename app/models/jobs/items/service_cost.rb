class ServiceCost < ActiveRecord::Base

  has_one :task_item, as: :itemable
  belongs_to :service_plan

  validates :description, :cost, :service_plan, presence: true
  validates :cost, numericality: { greater_than: 0 }

  after_initialize :set_description


  def service_plan=(service_plan)
    super
    set_cost
  end

  def set_description
    self.description = 'Service cost'
  end

  def set_cost
    self.cost = service_plan.cost if service_plan_id_changed?
  end

  def data
    [description, '', cost]
  end
end
