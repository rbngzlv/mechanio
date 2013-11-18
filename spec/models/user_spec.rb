require 'spec_helper'

describe User do

  let(:user) { build :user }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'combines first and last names into full name' do
    user.full_name.length.should > 0
    user.full_name.should eq "#{user.first_name} #{user.last_name}"
  end

  describe '#estimates' do
    it 'should has jobs with status pending and estimated' do
      user.estimates.count.should be_zero
      job_pending   = create :job_with_service, user: user, status: :pending
      job_estimated = create :job_with_service, user: user, status: :estimated
      job_assigned  = create :assigned_job,     user: user
      user.estimates.should include job_pending
      user.estimates.should include job_estimated
      user.estimates.should_not include job_assigned
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
