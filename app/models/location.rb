class Location < ActiveRecord::Base

  belongs_to :state

  validates :state, :address, :suburb, :postcode, presence: true, unless: :skip_validation
  validates :postcode, postcode: true, unless: :postcode_blank?

  attr_accessor :skip_geocoding, :skip_validation

  geocoded_by :geocoding_address

  after_save :get_coordinates, unless: :skip_geocoding

  scope :close_to, -> (latitude, longitude) {
    raise 'Cant sort by distance from invalid location' unless latitude && longitude

    order(%{
      ST_Distance(
        ST_GeographyFromText(
          'SRID=4326;POINT(' || locations.longitude || ' ' || locations.latitude || ')'
        ), ST_GeographyFromText('SRID=4326;POINT(%f %f)')
      )
    } % [longitude, latitude])
  }

  def full_address
    "#{address}, #{suburb} #{state_name}, #{postcode}"
  end

  def geocoding_address
    "#{address}, #{suburb} #{postcode}, Australia"
  end

  def get_coordinates
    Resque.enqueue(GeocoderWorker, self.id) unless Rails.env.test?
  end

  def state_name
    state.name
  end

  def geocoded?
    longitude && latitude
  end

  def postcode_blank?
    postcode.blank?
  end
end
