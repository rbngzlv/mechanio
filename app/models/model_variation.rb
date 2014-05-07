class ModelVariation < ActiveRecord::Base

  TRANSMISSION = ['Manual', 'Automatic', 'Semi-automatic']
  FUEL = ['Petrol', 'Diesel']

  belongs_to :make
  belongs_to :model
  belongs_to :body_type
  has_many :service_plans

  validates :title, :identifier, :make, :model, :from_year, :to_year, :transmission, :fuel, presence: true
  validates :from_year, :to_year, year: true
  validates :to_year, numericality: { greater_than: Proc.new { |r| r.from_year } }
  validates :transmission, inclusion: { in: TRANSMISSION }
  validates :fuel, inclusion: { in: FUEL }

  before_save :set_titles

  default_scope { order(:from_year) }

  delegate :name, to: :body_type, allow_nil: true, prefix: true

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
    scope.select(:id, :display_title, :detailed_title, :from_year, :to_year)
      .as_json(only: [:id, :display_title, :detailed_title], methods: [:title_with_year])
  end

  def set_titles
    self.display_title = [make.name, model.name, title].reject(&:blank?).join(' ')
    self.detailed_title = [title, body_type_name, transmission, fuel].reject(&:blank?).join(' ')
  end

  def title_with_year
    "#{display_title} #{from_year}-#{to_year}"
  end
end
