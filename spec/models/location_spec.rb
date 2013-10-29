require 'spec_helper'

describe Location do

  subject { build :location }

  it { should belong_to :state }

  it { should validate_presence_of :state }
  it { should validate_presence_of :address }
  it { should validate_presence_of :suburb }
  it { should validate_presence_of :postcode }
  it { should allow_value('0200').for(:postcode) }
  it { should_not allow_value('0300').for(:postcode).with_message('is not a valid postcode') }

  describe 'geocoding', :vcr do
    it 'should resolve address into coordinates' do
      location = build :location, address: '35 Stirling Highway', suburb:  'Crawley', postcode: '6009'
      location.geocode
      location.latitude.should_not be_blank
      location.longitude.should_not be_blank
    end
  end

  describe 'scope close_to' do
    let!(:location1) { create :location, latitude: 40.000000, longitude: -77.000000 }
    let!(:location2) { create :location, latitude: 39.010000, longitude: -75.990000 }
    let!(:location3) { create :location, latitude: 40.010000, longitude: -78.000000 }

    it 'should sort locations by distance' do
      Location.close_to(39.000000, -76.000000).should == [location2, location1, location3]
    end
  end
end
