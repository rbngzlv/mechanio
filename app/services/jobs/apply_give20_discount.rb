module Jobs
  class ApplyGive20Discount
    include ActionView::Helpers::NumberHelper

    def initialize(job)
      @job = job
      @invitation = job.user.invitation
    end

    def call
      return false unless referred_user? && has_no_discount_yet?

      title = number_to_currency(GIVE_GET_DISCOUNT_AMOUNT, precision: 0)
      discount = Discount.create(title: title, discount_type: 'amount', discount_value: GIVE_GET_DISCOUNT_AMOUNT, channel: 'give_get')

      @invitation.update(give_discount: discount)

      Jobs::ApplyDiscount.new(@job, discount.code).call
    end


    private

    def has_no_discount_yet?
      !@invitation.give_discount.present?
    end

    def referred_user?
      @job.user.referred_by.present?
    end
  end
end
