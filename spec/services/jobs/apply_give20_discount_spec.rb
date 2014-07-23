require 'spec_helper'

describe Jobs::ApplyGive20Discount do

  let(:user)          { create :user, referrer: referrer }
  let(:referrer)      { create :user }
  let(:invitation)    { create :invitation, user: user, sender: referrer }
  let(:job)           { create :job, :with_service, :estimated, user: user }
  let(:another_job)   { create :job, :with_service, :estimated, user: user }

  specify 'apply discount only once' do
    invitation

    job.final_cost.should eq 350
    another_job.final_cost.should eq 350

    result = Jobs::ApplyGive20Discount.new(job).call
    result.should be_true
    job.final_cost.should eq 330

    result = Jobs::ApplyGive20Discount.new(another_job).call
    result.should be_false
    another_job.final_cost.should eq 350
  end

  specify 'does not apply when there is no referrer' do
    user.update_attribute(:referred_by, nil)

    job.final_cost.should eq 350

    result = Jobs::ApplyGive20Discount.new(job).call
    result.should be_false

    job.final_cost.should eq 350
  end
end
