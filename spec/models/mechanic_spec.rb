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
  it { should have_one :payout_method }

  it { should respond_to :avatar }
  it { should respond_to :driver_license }
  it { should respond_to :abn }
  it { should respond_to :mechanic_license }

  it { should allow_value('').for(:years_as_a_mechanic) }
  it { should allow_value(123).for(:years_as_a_mechanic) }
  it { should_not allow_value('string').for(:years_as_a_mechanic) }

  it { should allow_value(nil).for(:abn_number) }
  it { should allow_value('12345678901').for(:abn_number) }
  it { should_not allow_value('123456789012').for(:abn_number) }
  it { should_not allow_value('1234567890').for(:abn_number) }

  it { should allow_value(nil).for(:driver_license_number) }
  it { should allow_value('12345678').for(:driver_license_number) }
  it { should_not allow_value('123456789').for(:driver_license_number) }
  it { should_not allow_value('1234567').for(:driver_license_number) }

  it { should allow_value('0412345678').for(:mobile_number) }
  it { should_not allow_value('12345678').for(:mobile_number) }
  it { should_not allow_value('04123456').for(:mobile_number) }

  it { should allow_value('0412345678').for(:business_mobile_number) }
  it { should_not allow_value('12345678').for(:business_mobile_number) }
  it { should_not allow_value('04123456').for(:business_mobile_number) }

  specify '#active' do
    mechanic1 = create :mechanic
    mechanic2 = create :mechanic, :suspended

    Mechanic.active.to_a.should eq [mechanic1]
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

  specify '#toggle_regions' do
    mechanic = create :mechanic
    region1 = create :region, postcode: '1234'
    region2 = create :region, postcode: '5678'

    mechanic.toggle_regions([region1.id], true)
    Mechanic.by_region('1234').to_a.should eq [mechanic]
    Mechanic.by_region('5678').to_a.should eq []

    mechanic.toggle_regions([region1.id], false)
    mechanic.toggle_regions([region2.id], true)
    Mechanic.by_region('1234').to_a.should eq []
    Mechanic.by_region('5678').to_a.should eq [mechanic]
  end

  describe '.build_associations' do
    let(:mechanic) { Mechanic.new }

    it 'should build location' do
      expect { mechanic.build_associations }.to change { mechanic.location }.from(nil)
    end

    it 'should build business_location' do
      expect { mechanic.build_associations }.to change { mechanic.business_location }.from(nil)
    end

    it 'should build payout_method' do
      expect { mechanic.build_associations }.to change { mechanic.payout_method }.from(nil)
    end

    it 'should not overwrite existing associations' do
      mechanic.build_associations
      expect { mechanic.build_associations }.not_to change { mechanic.location }
      expect { mechanic.build_associations }.not_to change { mechanic.business_location }
      expect { mechanic.build_associations }.not_to change { mechanic.payout_method }
    end
  end

  it '.suspend' do
    mechanic = build :mechanic
    mechanic.suspend
    mechanic.suspended_at.to_i.should eq DateTime.now.to_i
  end

  it '.activate' do
    mechanic = build :mechanic, :suspended
    mechanic.activate
    mechanic.suspended_at.should be_nil
  end

  describe 'authentication' do
    context 'mechanic active' do
      let(:mechanic) { build :mechanic }

      specify '.suspended?' do
        mechanic.suspended?.should be_false
      end

      specify '.active_for_authentication?' do
        mechanic.active_for_authentication?.should be_true
      end

      specify '.inactive_message' do
        mechanic.inactive_message.should be :inactive
      end
    end

    context 'mechanic suspended' do
      let(:mechanic) { build :mechanic, :suspended }

      specify '.suspended?' do
        mechanic.suspended?.should be_true
      end

      specify '.active_for_authentication?' do
        mechanic.active_for_authentication?.should be_false
      end

      specify '.inactive_message' do
        mechanic.inactive_message.should be :suspended
      end
    end
  end

  specify '#update_job_counters' do
    mechanic = create :mechanic
    mechanic.update_job_counters
    mechanic.current_jobs_count.should eq 0
    mechanic.completed_jobs_count.should eq 0

    mechanic.jobs << create(:job, :with_service, :assigned, mechanic: mechanic)
    mechanic.update_job_counters
    mechanic.current_jobs_count.should eq 1
    mechanic.completed_jobs_count.should eq 0

    mechanic.jobs << create(:job, :with_service, :completed, mechanic: mechanic)
    mechanic.update_job_counters
    mechanic.current_jobs_count.should eq 1
    mechanic.completed_jobs_count.should eq 1
  end
end
