require 'spec_helper'

describe BraintreeClient, :vcr do

  let(:client)      { BraintreeClient.new }
  let(:job)         { create :job, :with_service, :assigned, credit_card: users_card }
  let(:customer)         { { first_name: 'First', last_name: 'Last', email: 'email@host.com' } }

  # Braintree provided values for simulating success/error
  let(:successful_card)         { { number: '4111 1111 1111 1111', cvv: '123', expiration_date: '11/08' } }
  let(:unsuccessful_card)       { { number: '4000 1111 1111 1115', cvv: '123', expiration_date: '11/08' } }
  let(:successful_amount)       { '100' }
  let(:unsuccessful_amount)     { '2000' }

  context '#create_customer' do
    specify 'success' do
      response = client.create_customer(customer)
      response.success?.should be_true
    end

    specify 'failure' do
      customer[:email] = 'invalid'
      response = client.create_customer(customer)
      response.success?.should be_false
    end
  end

  context '#create_customer_with_card' do
    specify 'success' do
      result = client.create_customer_with_card(customer, successful_card)

      result.success?.should be_true
      card = result.customer.credit_cards.last
      card.customer_id.should eq '86091716'
      card.last_4.should eq '1111'
    end

    specify 'failure' do
      result = client.create_customer_with_card(customer, unsuccessful_card)

      result.success?.should be_false
    end
  end

  context '#create_card' do
    before do
      @customer_id = client.create_customer(customer).customer.id
    end

    specify 'success' do
      result = client.create_card(successful_card, @customer_id)

      result.success?.should be_true
      result.credit_card.customer_id.should eq @customer_id
      result.credit_card.last_4.should eq '1111'
    end

    specify 'card does not verify' do
      result = client.create_card(unsuccessful_card, @customer_id)

      result.success?.should be_false
    end
  end
end
