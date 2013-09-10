class Brand < ActiveRecord::Base

  validates :name, presence: true
end
