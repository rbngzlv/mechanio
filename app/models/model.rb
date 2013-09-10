class Model < ActiveRecord::Base

  belongs_to :brand

  has_many :model_variations

  validates :name, :brand, presence: true
end
