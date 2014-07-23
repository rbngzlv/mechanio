require 'spec_helper'

describe Payments::ChargeUser do
  let(:user)              { create(:user) }
  let(:job)               { create(:job, :completed, :with_service, user: user) }
  let(:successful_card)   { { number: '4111 1111 1111 1111', cvv: '123', expiration_month: '11', expiration_year: '2008' } }

  before do
    Payments::VerifyCard.new.call(user, job, successful_card)
  end

  specify 'success', :vcr do
    job.transaction_id.should be_nil
    job.transaction_status.should be_nil
    job.transaction_errors.should be_nil

    result = Payments::ChargeUser.new(job).call

    result.should be_true
    job.reload.transaction_id.should_not be_nil
    job.transaction_status.should eq 'submitted_for_settlement'
    job.status.should eq 'charged'
  end

  specify 'error', :vcr do
    # set final cost to a special Braintree value to simulate error
    job.update_attribute(:final_cost, 2000)

    job.transaction_id.should be_nil
    job.transaction_status.should be_nil
    job.transaction_errors.should be_nil

    result = Payments::ChargeUser.new(job).call

    result.should be_false
    job.reload.transaction_id.should_not be_nil
    job.transaction_status.should_not be_nil
    job.transaction_status.should eq 'processor_declined'
    job.status.should eq 'charge_failed'
  end
end
