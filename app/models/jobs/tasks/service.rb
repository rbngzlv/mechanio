class Service < Task

  belongs_to :service_plan

  validates :service_plan, presence: true

  after_validation :set_title, :itemize, :set_cost, if: :service_plan

  def set_title
    self.title = service_plan.display_title
  end

  def itemize
    return unless new_record?

    item = FixedAmount.new(
      description: service_plan.display_title,
      cost: service_plan.cost
    )

    task_items.build(itemable: item)
  end
end
