class Location < ActiveRecord::Base

  belongs_to :locatable, polymorphic: true
  belongs_to :state

  validates :state, :address, :suburb, :postcode, presence: true
  validates :postcode, postcode: true
end
