class Service < Task

  belongs_to :service_plan

  validates :service_plan, presence: true

  before_validation :set_title, :itemize, if: :service_plan

  def set_title
    self.title = "#{service_plan.display_title} service"
  end

  def itemize
    item = ServiceCost.new(service_plan: service_plan)

    task_items.where(itemable_type: 'ServiceCost').delete_all
    task_items.reload.build(itemable: item)
  end
end
