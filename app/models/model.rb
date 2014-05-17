class Model < ActiveRecord::Base

  belongs_to :make

  has_many :model_variations

  validates :name, :make, presence: true

  default_scope { order(:name) }
end
