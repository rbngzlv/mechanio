require 'braintree'

class BraintreeClientError < StandardError; end

class BraintreeClient

  def create_customer(customer_fields)
    Braintree::Customer.create(customer_fields)
  end

  def create_customer_with_card(customer_fields, card_fields)
    Braintree::Customer.create(
      customer_fields.merge({
        credit_card: card_fields.merge({ options: {
          verify_card: true
        }})
      })
    )
  end

  def create_card(card_fields, customer_id)
    Braintree::CreditCard.create(
      card_fields.merge({
        customer_id: customer_id,
        options: {
          verify_card: true
        }
      })
    )
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
end
