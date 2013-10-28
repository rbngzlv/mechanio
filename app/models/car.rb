class Car < ActiveRecord::Base

  belongs_to :user
  belongs_to :model_variation

  before_save :set_display_title

  validates :model_variation, :year, presence: true
  validates :user, presence: true, unless: :skip_user_validation
  validates :year, year: true
  validates :last_service_kms, numericality: true, allow_blank: true

  attr_accessor :skip_user_validation

  delegate :service_plans, to: :model_variation

  def set_display_title
    self.display_title = "#{year} #{model_variation.display_title}"
  end
end
