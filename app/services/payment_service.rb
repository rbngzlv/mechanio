class PaymentServiceError < StandardError; end

class PaymentService

  def verify_card(user, job, credit_card_params)
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

  def charge_user_for_job(user_id, job_id)
    user = User.find(user_id)
    job = Job.find(job_id)

    unless job.credit_card.braintree_customer_id == user.braintree_customer_id
      raise PaymentServiceError, 'Attempt to use a card that belongs to different customer'
    end

    result = braintree_client.create_transaction({
      amount: job.cost,
      order_id: job.id,
      payment_method_token: job.credit_card.token
    })

    if result.transaction
      job.transaction_id     = result.transaction.id
      job.transaction_status = result.transaction.status
    end

    if result.respond_to?(:errors) && result.errors.size > 0
      job.transaction_errors = result.errors.inspect
    end

    if result.success?
      job.changed!
      AdminMailer.async.payment_error(job.id)
    else
      job.change_failed!
      AdminMailer.async.payment_success(job.id)
    end

    job.save

    result.success?
  end


  private

  def braintree_client
    @client ||= BraintreeClient.new
  end
end
