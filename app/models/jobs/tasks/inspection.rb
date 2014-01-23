class Inspection < Task

  validates :title, :description, presence: true

  def set_cost
    self.cost = 80
  end
end
