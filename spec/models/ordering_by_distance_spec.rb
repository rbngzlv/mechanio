require 'spec_helper'

describe 'sorting' do
  let!(:location1) { create :location, :with_type, latitude: 40.000000, longitude: -77.000000 }
  let!(:location2) { create :location, :with_type, latitude: 39.010000, longitude: -75.990000 }
  let!(:location3) { create :location, :with_type, latitude: 40.010000, longitude: -78.000000 }

  describe 'sort locations by distance' do
    subject { Location.close_to(39.000000, -76.000000) }

    it 'tmp name' do
      should == [location2, location1, location3]
    end
  end

  describe 'sort mechanics by distance' do
    let!(:mechanic1) { create :mechanic, location: location1}
    let!(:mechanic2) { create :mechanic, location: location2}
    let!(:mechanic3) { create :mechanic, location: location3}

    subject { Mechanic.close_to(39.000000, -76.000000)}

    it 'tmp name' do
      should == [mechanic2, mechanic1, mechanic3]
    end
  end
end
