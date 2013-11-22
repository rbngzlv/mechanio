require 'spec_helper'

# describe BraintreeClient do
describe BraintreeClient, :vcr do

  let(:user)        { create :user }
  let(:users_card)  { user.credit_cards.first }
  let(:client)      { BraintreeClient.new(user) }
  let(:job)         { create :job, :with_service, :assigned, :confirmed, credit_card: users_card }
  let(:expiration_date)         { '11/08' }

  # Braintree provided values for simulating success/error
  let(:successful_cc_number)    { '4111 1111 1111 1111' }
  let(:unsuccessful_cc_number)  { '4000 1111 1111 1115' }
  let(:successful_amount)       { '100' }
  let(:unsuccessful_amount)     { '2000' }
  let(:successful_cvv)          { '123' }

  context '#create_customer' do
    specify 'success' do
      user.braintree_customer_id.should be_nil
      client.create_customer.should_not be_false
      user.reload.braintree_customer_id.should_not be_nil
    end

    specify 'failure' do
      client.user.email = 'invalid'
      user.braintree_customer_id.should be_nil
      client.create_customer.should be_false
      user.reload.braintree_customer_id.should be_nil
    end
  end

  context '#create_customer_with_card' do
    specify 'success' do
      result = client.create_customer_with_card(successful_card)

      user.reload.braintree_customer_id.should_not be_nil
      users_card.last_4.should eq '1111'
      users_card.braintree_customer_id.should eq user.braintree_customer_id
    end

    specify 'failure' do
      result = client.create_customer_with_card(unsuccessful_card)

      result.should be_false
      user.braintree_customer_id.should be_nil
      user.credit_cards.count.should eq 0
    end
  end

  context '#create_card' do
    before { client.create_customer }

    specify 'success' do
      client.create_card(successful_card).should_not be_false

      users_card.last_4.should eq '1111'
      users_card.braintree_customer_id.should eq user.braintree_customer_id
    end

    specify 'card does not verify' do
      client.create_card(unsuccessful_card).should be_false

      user.credit_cards.count.should eq 0
    end
  end

  context '#pay_for_job' do
    before do
      client.create_customer_with_card(successful_card)
    end

    specify 'success' do
      client.pay_for_job(job).should be_true
      job.transaction_id.should_not be_nil
      job.transaction_status.should eq 'submitted_for_settlement'
      job.transaction_errors.should be_nil
    end

    specify 'failure' do
      job.stub(:cost).and_return(unsuccessful_amount)
      client.pay_for_job(job).should be_false
      job.transaction_id.should_not be_nil
      job.transaction_status.should eq 'processor_declined'
      job.transaction_errors.should be_nil
    end

    specify 'validation error' do
      job.stub(:cost).and_return(-100)
      client.pay_for_job(job).should be_false
      job.transaction_id.should be_nil
      job.transaction_status.should be_nil
      job.transaction_errors.should_not be_nil
    end
  end

  def successful_card
    {
      number: successful_cc_number,
      cvv: successful_cvv,
      expiration_date: expiration_date
    }
  end

  def unsuccessful_card
    {
      number: unsuccessful_cc_number,
      cvv: successful_cvv,
      expiration_date: expiration_date
    }
  end
end
