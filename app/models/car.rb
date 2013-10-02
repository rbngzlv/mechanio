class Car < ActiveRecord::Base

  belongs_to :user
  belongs_to :model_variation

  before_save :set_display_title

  validates :user_id, :model_variation_id, :year, presence: true
  validates :year, year: true

  def set_display_title
    self.display_title = "#{year} #{model_variation.display_title}"
  end
end
