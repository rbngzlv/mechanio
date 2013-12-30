require 'spec_helper'

describe Mechanic do

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :dob }
  it { should validate_presence_of :location }

  it { should belong_to :location }
  it { should belong_to :business_location }
  it { should have_many :jobs }

  it { should respond_to :avatar }
  it { should respond_to :driver_license }
  it { should respond_to :abn }
  it { should respond_to :mechanic_license }

  describe '#by_location' do
    let!(:mechanic1) { create :mechanic, location: create(:location, latitude: 40.00, longitude: -77.00, postcode: '1234') }
    let!(:mechanic2) { create :mechanic, location: create(:location, latitude: 39.01, longitude: -75.99, postcode: '2345') }
    let!(:mechanic3) { create :mechanic, location: create(:location, latitude: 40.01, longitude: -78.00, postcode: '3456') }
    let(:geocoded_location) { create(:location, latitude: 39.00, longitude: -76.00) }
    let(:postcode_location) { create(:location, postcode: '2345') }

    it 'sorts mechanics by distance' do
      Mechanic.by_location(geocoded_location).should == [mechanic2, mechanic1, mechanic3]
    end

    it 'finds mechanics by postcode' do
      Mechanic.by_location(postcode_location).should == [mechanic2]
    end
  end

  specify '#by_region' do
    mechanic1 = create :mechanic, mechanic_regions: [create(:mechanic_region, postcode: '1234'), create(:mechanic_region, postcode: '1234')]
    mechanic2 = create :mechanic, mechanic_regions: [create(:mechanic_region, postcode: '4567')]

    Mechanic.by_region('1234').should eq [mechanic1]
  end

  describe '.build_association' do
    let(:mechanic) { Mechanic.new }

    it 'should create location association' do
      expect { mechanic.build_associations }.to change { mechanic.location }.from(nil)
    end

    it 'should create business location association' do
      expect { mechanic.build_associations }.to change { mechanic.business_location }.from(nil)
    end

    it 'should not change associations if their are exists' do
      mechanic.build_associations
      expect { mechanic.build_associations }.not_to change { mechanic.location }
      expect { mechanic.build_associations }.not_to change { mechanic.business_location }
    end
  end
end
