require 'spec_helper'

describe 'sorting by distance' do
  let!(:location1) { create :location, :with_type, latitude: 40.000000, longitude: -77.000000 }
  let!(:location2) { create :location, :with_type, latitude: 39.010000, longitude: -75.990000 }
  let!(:location3) { create :location, :with_type, latitude: 40.010000, longitude: -78.000000 }

  specify 'sort locations' do
    Location.close_to(39.000000, -76.000000).should == [location2, location1, location3]
  end

  specify 'sort mechanics' do
    mechanic1 = create :mechanic, location: location1
    mechanic2 = create :mechanic, location: location2
    mechanic3 = create :mechanic, location: location3

    Mechanic.close_to(39.000000, -76.000000).should == [mechanic2, mechanic1, mechanic3]
  end
end
