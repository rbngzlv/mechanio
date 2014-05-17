class Make < ActiveRecord::Base

  has_many :models
  has_many :model_variations

  validates :name, presence: true

  default_scope { order(:name) }

end
