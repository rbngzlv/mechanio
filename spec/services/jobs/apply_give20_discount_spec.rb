require 'spec_helper'

describe Jobs::ApplyGive20Discount do

  let(:service)       { Jobs::ApplyGive20Discount.new(job) }
  let(:user)          { create :user, referred_by: referrer.id }
  let(:referrer)      { create :user }
  let(:job)           { create :job, :with_service, :estimated, user: user }

  specify 'apply when this is a first job' do
    job.final_cost.should eq 350
    service.call.should be_true
    job.final_cost.should eq 330
  end

  specify 'does not apply when this is not a first job' do
    create :job, :with_service, :estimated, user: user

    job.final_cost.should eq 350
    service.call.should be_false
    job.final_cost.should eq 350
  end

  specify 'does not apply when there is no referrer' do
    create :job, :with_service, :estimated, user: user
    user.update_attribute(:referred_by, nil)

    job.final_cost.should eq 350
    service.call.should be_false
    job.final_cost.should eq 350
  end
end
