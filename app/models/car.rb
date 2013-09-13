class Car < ActiveRecord::Base

  belongs_to :user
  belongs_to :model_variation

  validates :user_id, :model_variation_id, :year, presence: true
  validates :year, year: true
end
