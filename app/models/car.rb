class Car < ActiveRecord::Base

  belongs_to :user
  belongs_to :model_variation

  before_save :set_display_title

  validates :model_variation, :year, presence: true
  validates :user, presence: true, unless: :skip_user_validation
  validates :year, year: true

  attr_accessor :skip_user_validation

  def set_display_title
    self.display_title = "#{year} #{model_variation.display_title}"
  end
end
