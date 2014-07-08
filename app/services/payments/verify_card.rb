module Payments
  class VerifyCard

    def call(user, job, credit_card_params)
      result = if user.braintree_customer_id
        braintree_client.create_card(credit_card_params, user.braintree_customer_id)
      else
        customer_params = { first_name: user.first_name, last_name: user.last_name, email: user.email }
        braintree_client.create_customer_with_card(customer_params, credit_card_params)
      end

      if result.success?
        card_data = result.respond_to?(:customer) ? result.customer.credit_cards.last : result.credit_card
        user.update_attribute(:braintree_customer_id, card_data.customer_id)
        credit_card = user.credit_cards.create(
          last_4: card_data.last_4,
          token: card_data.token,
          braintree_customer_id: card_data.customer_id
        )
        job.update_attribute(:credit_card_id, credit_card.id)
      else
        false
      end
    end


    private

    def braintree_client
      @client ||= BraintreeClient.new
    end
  end
end
