module Jobs
  class ApplyGet20Discount
    include ActionView::Helpers::NumberHelper

    def initialize(job)
      @job = job
      @invitation = job.user.invitation
    end

    def call
      return false unless referred_user? && has_no_discount_yet?

      title = number_to_currency(GIVE_GET_DISCOUNT_AMOUNT, precision: 0)
      discount = Discount.create(title: title, discount_type: 'amount', discount_value: GIVE_GET_DISCOUNT_AMOUNT, channel: 'give_get')

      @invitation.update(get_discount: discount)
    end


    private

    def referred_user?
      @job.user.referred_by.present?
    end

    def has_no_discount_yet?
      !@invitation.get_discount.present?
    end
  end
end
