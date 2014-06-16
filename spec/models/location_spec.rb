require 'spec_helper'

describe Location do

  subject { build :location }

  it { should belong_to :suburb }

  it { should validate_presence_of :address }
  it { should validate_presence_of :suburb }

  specify '#full_address' do
    location = build :location, address: '35 Stirling Highway', suburb: build(:sydney_suburb)
    location.full_address.should eq '35 Stirling Highway, Sydney, NSW 2012'
  end

  describe 'geocoding', :vcr do
    it 'should resolve address into coordinates' do
      location = build :location, address: '35 Stirling Highway', suburb: build(:sydney_suburb), postcode: '6009'
      location.geocode
      location.latitude.should_not be_blank
      location.longitude.should_not be_blank
    end
  end

  describe '#geocoded?' do
    it 'is false when location is not geocoded' do
      location = build_stubbed(:location)
      expect(location.geocoded?).to be_false
    end

    it 'is true when location is geocoded' do
      location = build_stubbed(:location, :with_coordinates)
      expect(location.geocoded?).to be_true
    end
  end

  describe 'scope close_to' do
    let!(:location1) { create :location, latitude: 40.000000, longitude: -77.000000 }
    let!(:location2) { create :location, latitude: 39.010000, longitude: -75.990000 }
    let!(:location3) { create :location, latitude: 40.010000, longitude: -78.000000 }

    it 'should sort locations by distance' do
      Location.close_to(39.000000, -76.000000).should == [location2, location1, location3]
    end

    it 'raises error when coordinates are invalid' do
      expect {
        Location.close_to(nil, nil)
      }.to raise_error(StandardError, 'Cant sort by distance from invalid location')
    end
  end
end
