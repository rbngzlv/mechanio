module Payments
  class ChargeUser

    def initialize(job)
      @job = job
    end

    def call
      braintree_client = BraintreeClient.new

      result = braintree_client.create_transaction({
        amount: @job.final_cost,
        order_id: @job.id,
        payment_method_token: @job.credit_card.token
      })

      if result.transaction
        @job.transaction_id     = result.transaction.id
        @job.transaction_status = result.transaction.status
      end

      if result.respond_to?(:errors) && result.errors.size > 0
        @job.transaction_errors = result.errors.inspect
      end

      if result.success?
        @job.charged
        AdminMailer.async.payment_error(@job.id)
      else
        @job.charge_failed!
        AdminMailer.async.payment_success(@job.id)
      end

      result.success?
    end
  end

  class PaymentError < StandardError; end
end
