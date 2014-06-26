class Service < Task

  belongs_to :service_plan

  validates :service_plan, presence: true

  before_validation :set_title, :itemize, if: :service_plan

  def set_title
    self.title = "#{service_plan.display_title} service"
  end

  def itemize
    if item = find_service_item
      item.itemable.update(service_plan: service_plan)
    else
      task_items.build itemable: ServiceCost.new(service_plan: service_plan)
    end
  end

  def find_service_item
    task_items.find { |i| i.itemable_type == 'ServiceCost' }
  end
end
