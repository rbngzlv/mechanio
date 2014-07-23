require 'spec_helper'

describe User do

  let(:user) { build :user, first_name: 'First', last_name: 'Last' }

  it { should have_many :cars }
  it { should have_many :jobs }
  it { should have_many :credit_cards }
  it { should have_many :authentications }
  it { should have_many :ratings }
  it { should belong_to :location }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'combines first and last names into full name' do
    user.full_name.should eq "First Last"
  end

  describe 'job scopes' do
    let!(:pending_job)   { create :job, :pending,   :with_service, user: user }
    let!(:estimated_job) { create :job, :estimated, :with_service, user: user }
    let!(:assigned_job)  { create :job, :assigned,  :with_service, user: user }
    let!(:completed_job) { create :job, :completed, :with_service, user: user }

    it 'gets correct jobs' do
      user.estimated_jobs.should   eq [estimated_job]
      user.current_jobs.should     eq [assigned_job]
      user.past_jobs.should        eq [completed_job]
      user.pending_and_estimated_jobs.should =~ [pending_job, estimated_job]
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

  describe 'delete user with jobs' do
    let!(:user) { create :user }
    let!(:job)  { create :job, :with_service, user: user }

    it 'deletes user' do
      expect { user.destroy }.to change { User.count }.by -1
    end

    it 'nullifies jobs' do
      expect { user.destroy }.to change { job.reload.user_id }.from(user.id).to(nil)
    end
  end

  it 'generates referral code on create' do
    user.referral_code.should be_nil
    user.save
    user.reload.referral_code.length.should eq 8
  end
end
