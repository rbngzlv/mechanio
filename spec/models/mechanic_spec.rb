require 'spec_helper'

describe Mechanic do

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :dob }
  it { should validate_presence_of :location }
  it { should validate_presence_of :mobile_number }

  it { should belong_to :location }
  it { should belong_to :business_location }
  it { should have_many :jobs }

  it { should respond_to :avatar }
  it { should respond_to :driver_license }
  it { should respond_to :abn }
  it { should respond_to :mechanic_license }

  it { should allow_value("12345678901").for(:abn_number) }
  it { should_not allow_value("123456789012").for(:abn_number) }
  it do
    should_not allow_value("1234567890").for(:abn_number)
    subject.errors.messages[:abn_number].should be_eql ["It should contain 11 numbers"]
  end

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
end
