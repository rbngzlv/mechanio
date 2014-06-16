class Location < ActiveRecord::Base

  belongs_to :state
  belongs_to :suburb, -> { suburbs }, class_name: 'Region'

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

  def suburb=(value)
    if value.present? && value.is_a?(String)
      if suburb = find_suburb(value)
        super(suburb)
      end
    elsif value.is_a?(Region) || value.nil?
      super(value)
    end
  end

  def find_suburb(display_name)
    Region.suburbs.find_by_display_name(display_name)
  end

  def full_address
    "#{address}, #{suburb_name}"
  end

  def geocoding_address
    "#{address}, #{suburb_name} Australia"
  end

  def get_coordinates
    Resque.enqueue(GeocoderWorker, self.id) unless Rails.env.test?
  end

  def state_name
    state.name
  end

  def suburb_name
    suburb.display_name if suburb.present?
  end

  def geocoded?
    longitude && latitude
  end

  def postcode_blank?
    postcode.blank?
  end
end
