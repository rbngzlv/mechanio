class GeocoderWorker
  @queue = :geocoder

  def self.perform(location_id)
    location = Location.find location_id
    location.geocode
    location.skip_geocoding = true # this is a flag that prevents geocoding to be triggered again in after_save callback
    location.save
  end
end
