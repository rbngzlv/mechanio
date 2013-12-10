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

  describe '#add_credit_card', :vcr do
    let(:successful_card)   { { number: '4111 1111 1111 1111', cvv: '123', expiration_date: '11/08' } }
    let(:unsuccessful_card) { { number: '4000 1111 1111 1115', cvv: '123', expiration_date: '11/08' } }

    it 'creates braintree customer with a card' do
      expect {
        user.add_credit_card(successful_card)
      }.to change{user.credit_cards.count}.by(1)
      user.braintree_customer_id.should eq '12506094'
    end

    it 'add a card to existing braintree customer' do
      response = braintree_client.create_customer(user.as_json(only: [:first_name, :last_name, :email]))
      user.braintree_customer_id = response.customer.id

      expect {
        user.add_credit_card(successful_card)
      }.to change{user.credit_cards.count}.by(1)
    end

    it 'returns false on failure' do
      expect {
        user.add_credit_card(unsuccessful_card).should be_false
      }.not_to change{user.credit_cards.count}
    end
  end
end
