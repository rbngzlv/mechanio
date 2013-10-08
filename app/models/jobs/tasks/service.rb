class Service < Task

  belongs_to :service_plan

  validates :service_plan, presence: true

  before_create :set_title

  def set_title
    self.title = service_plan.display_title
  end
end
