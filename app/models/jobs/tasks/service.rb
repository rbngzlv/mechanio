class Service < Task

  belongs_to :service_plan

  validates :service_plan, presence: true
end
