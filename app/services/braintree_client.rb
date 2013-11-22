require 'braintree'

class BraintreeClientError < StandardError; end

class BraintreeClient

  attr_accessor :user, :result

  def initialize(user)
    @user = user
  end

  def pay_for_job(job)
    unless job.credit_card.braintree_customer_id == @user.braintree_customer_id
      raise BraintreeClientError, 'Attempt to use a card that belongs to different customer'
    end

    @result = create_transaction({
      amount: job.cost,
      order_id: job.id,
      payment_method_token: job.credit_card.token,
    })

    if @result.transaction
      job.transaction_id     = @result.transaction.id 
      job.transaction_status = @result.transaction.status
    end
    if @result.respond_to?(:errors) && @result.errors.size > 0
      job.transaction_errors = @result.errors.inspect
    end
    job.save

    @result.success?
  end

  def find_customer
    Braintree::Customer.find(@user.braintree_customer_id)
  rescue Braintree::NotFoundError
    false
  end

  def create_customer
    @result = Braintree::Customer.create(customer_fields)

    if @result.success?
      @user.update_attribute(:braintree_customer_id, @result.customer.id)
    else
      false
    end
  end

  def create_customer_with_card(params)
    @result = Braintree::Customer.create(
      customer_fields.merge({
        credit_card: card_fields(params)
      })
    )

    if @result.success?
      @user.update_attribute(:braintree_customer_id, @result.customer.id)
      create_card_from_response(@result.customer.credit_cards.last)
    else
      false
    end
  end

  def create_card(params)
    @result = Braintree::CreditCard.create(
      card_fields(params).merge({
        customer_id: @user.braintree_customer_id
      })
    )

    if @result.success?
      create_card_from_response(@result.credit_card)
    else
      false
    end
  end

  def create_transaction(params)
    Braintree::Transaction.sale(
      amount: params[:amount],
      order_id: params[:order_id],
      payment_method_token: params[:payment_method_token],
      options: {
        submit_for_settlement: true
      }
    )
  end

  def create_card_from_response(card)
    @user.credit_cards.create(
      last_4: card.last_4,
      token: card.token,
      braintree_customer_id: card.customer_id
    )
  end

  def customer_fields
    {
      first_name: @user.first_name,
      last_name: @user.last_name,
      email: @user.email
    }
  end

  def card_fields(params)
    {
      cardholder_name: @user.full_name,
      number: params[:number],
      cvv: params[:cvv],
      expiration_date: params[:expiration_date],
      options: {
        verify_card: true
      }
    }
  end
end
