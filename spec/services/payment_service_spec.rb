require 'spec_helper'

describe PaymentService do
  let(:payment_service)   { PaymentService.new }
  let(:braintree_client)  { BraintreeClient.new }
  let(:user)              { create(:user) }
  let(:job)               { create(:job, :with_service, user: user) }
  let(:successful_card)   { { number: '4111 1111 1111 1111', cvv: '123', expiration_month: '11', expiration_year: '2008' } }
  let(:unsuccessful_card) { { number: '4000 1111 1111 1115', cvv: '123', expiration_month: '11', expiration_year: '2008' } }

  describe '#verify_card', :vcr do
    it 'creates braintree customer with a card' do
      payment_service.verify_card(user, job, successful_card)

      user.credit_cards.count.should eq 1
      user.braintree_customer_id.should eq '36611421'
      job.credit_card_id.should eq user.credit_cards.last.id
    end

    it 'add a card to existing braintree customer' do
      response = braintree_client.create_customer(user.as_json(only: [:first_name, :last_name, :email]))
      user.braintree_customer_id = response.customer.id

      payment_service.verify_card(user, job, successful_card)

      user.credit_cards.count.should eq 1
      user.braintree_customer_id.should eq '50123119'
      job.credit_card_id.should eq user.credit_cards.last.id
    end

    it 'returns false on failure' do
      payment_service.verify_card(user, job, unsuccessful_card)

      user.credit_cards.count.should eq 0
      job.credit_card.should be_nil
    end
  end

  describe '#charge_user_for_job', :pending do
  end
end
