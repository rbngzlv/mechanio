require 'spec_helper'

describe Mechanic do

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :dob }
  it { should validate_presence_of :location }

  it { should have_one :location }
  it { should have_one :business_location }
  it { should have_many :jobs }

  it { should respond_to :avatar }
  it { should respond_to :driver_license }
  it { should respond_to :abn }
  it { should respond_to :mechanic_license }

  describe 'scope close_to' do
    let(:location1) { create :location, :with_type, latitude: 40.000000, longitude: -77.000000 }
    let(:location2) { create :location, :with_type, latitude: 39.010000, longitude: -75.990000 }
    let(:location3) { create :location, :with_type, latitude: 40.010000, longitude: -78.000000 }
    let!(:mechanic1) { create :mechanic, location: location1 }
    let!(:mechanic2) { create :mechanic, location: location2 }
    let!(:mechanic3) { create :mechanic, location: location3 }

    it 'should sort mechanics by distance' do
      Mechanic.close_to(39.000000, -76.000000).should == [mechanic2, mechanic1, mechanic3]
    end
  end
end
