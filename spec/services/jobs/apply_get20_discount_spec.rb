require 'spec_helper'

describe Jobs::ApplyGet20Discount do

  let(:user)          { create :user, referrer: referrer }
  let(:referrer)      { create :user }
  let(:invitation)    { create :invitation, user: user, sender: referrer }
  let(:job)           { create :job, :with_service, :estimated, user: user }
  let(:another_job)   { create :job, :with_service, :estimated, user: user }

  specify 'create discount only once' do
    invitation
    Discount.count.should eq 0
    invitation.get_discount.should be_nil

    result = Jobs::ApplyGet20Discount.new(job).call
    result.should be_true
    Discount.count.should eq 1
    invitation.reload.get_discount.should_not be_nil

    result = Jobs::ApplyGet20Discount.new(job).call
    result.should be_false
    Discount.count.should eq 1
    invitation.reload.get_discount.should_not be_nil
  end
end
