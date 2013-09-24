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

  before_save :set_titles

  default_scope { order(:from_year) }

  def self.search(params = {})
    from_year = params.delete(:from_year)
    to_year = params.delete(:to_year)
    scope = where(params).includes(:make, :model, :body_type).order('makes.name, models.name, model_variations.title')
    scope = scope.where('from_year >= ?', from_year) unless from_year.blank?
    scope = scope.where('to_year <= ?', to_year) unless to_year.blank?
    scope
  end

  def self.to_options(params)
    return [] if params.empty?
    year = params.delete(:year)
    scope = where(params)
    scope = scope.where('? BETWEEN from_year AND to_year', year) unless year.blank?
    scope.select(:id, :display_title, :detailed_title).each.map do |m|
      { id: m.id, display_title: m.display_title, detailed_title: m.detailed_title }
    end
  end

  def set_titles
    self.display_title = "#{make.name} #{model.name} #{title}"
    self.detailed_title = "#{title} #{body_type.name} #{transmission} #{fuel} #{from_year}-#{to_year}"
  end
end
