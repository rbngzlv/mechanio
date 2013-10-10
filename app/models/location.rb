class Location < ActiveRecord::Base

  belongs_to :locatable, polymorphic: true
  belongs_to :state

  validates :state, :address, :suburb, :postcode, presence: true
  validates :postcode, postcode: true

  attr_accessor :skip_geocoding

  geocoded_by :full_address

  after_save :get_coordinates, unless: :skip_geocoding

  def full_address
    "#{address}, #{suburb} #{postcode}, Australia"
  end

  def get_coordinates
    Resque.enqueue(GeocoderWorker, self.id) unless Rails.env.test?
  end

  def state_name
    state.name
  end
end
