class Repair < Task

  has_and_belongs_to_many :symptoms

  validates :title, presence: true

  after_validation :set_cost
end
