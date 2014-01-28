require 'spec_helper'

describe User do

  let(:user) { build :user, first_name: 'First', last_name: 'Last' }

  it { should have_many :cars }
  it { should have_many :jobs }
  it { should have_many :credit_cards }
  it { should have_many :authentications }
  it { should belong_to :location }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'combines first and last names into full name' do
    user.full_name.should eq "First Last"
  end

  describe 'job scopes' do
    let!(:pending_job)   { create :job_with_service, :pending,   user: user }
    let!(:estimated_job) { create :job_with_service, :estimated, user: user }
    let!(:assigned_job)  { create :job_with_service, :assigned,  user: user }

    it 'gets correct jobs' do
      user.estimates.should     eq [estimated_job]
      user.appointments.should  eq [assigned_job]
      user.pending_and_estimated.should =~ [pending_job, estimated_job]
    end
  end

  describe '#cars' do
    it 'should contain only existing cars(not soft deleted)' do
      user.save
      user.cars << (car = create(:car))
      user.cars << create(:car, :deleted)
      user.reload.cars.length.should be 1
      user.cars.first.should be_eql car
    end
  end
end
