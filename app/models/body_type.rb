class BodyType < ActiveRecord::Base

  validates :name, presence: true
end
