class ModelVariation < ActiveRecord::Base

  TRANSMISSION = ['Manual', 'Automatic', 'Semi-automatic']
  FUEL = ['Petrol', 'Diesel']

  belongs_to :brand
  belongs_to :model
  belongs_to :body_type

  validates :title, :identifier, :brand_id, :model_id, :body_type_id, :from_year, :to_year, :transmission, :fuel, presence: true
  validates :from_year, :to_year, year: true
  validates :to_year, numericality: { greater_than: Proc.new { |r| r.from_year } }
  validates :transmission, inclusion: { in: TRANSMISSION }
  validates :fuel, inclusion: { in: FUEL }
end
