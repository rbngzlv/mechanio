class ModelVariation < ActiveRecord::Base

  TRANSMISSION = ['Manual', 'Automatic', 'Semi-automatic']
  FUEL = ['Petrol', 'Diesel']

  belongs_to :make
  belongs_to :model
  belongs_to :body_type

  validates :title, :identifier, :make_id, :model_id, :body_type_id, :from_year, :to_year, :transmission, :fuel, presence: true
  validates :from_year, :to_year, year: true
  validates :to_year, numericality: { greater_than: Proc.new { |r| r.from_year } }
  validates :transmission, inclusion: { in: TRANSMISSION }
  validates :fuel, inclusion: { in: FUEL }

  before_save :set_display_title

  default_scope { order(:from_year) }

  def self.search(params = {})
    from_year = params.delete(:from_year)
    to_year = params.delete(:to_year)
    scope = where(params).includes(:make, :model, :body_type).order('makes.name, models.name, model_variations.title')
    scope = scope.where('from_year >= ?', from_year) unless from_year.blank?
    scope = scope.where('to_year <= ?', to_year) unless to_year.blank?
    scope
  end

  def set_display_title
    self.display_title = "#{title} #{body_type.name} #{transmission} #{fuel} #{from_year}-#{to_year}"
  end
end
