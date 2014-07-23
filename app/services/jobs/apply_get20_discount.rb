module Jobs
  class ApplyGet20Discount

    def initialize(job)
      @job = job
      @invitation = job.user.invitation
    end

    def call
      return false unless referred_user? && has_no_discount_yet?

      discount = Discount.create(title: '$20', discount_type: 'amount', discount_value: 20, channel: 'give20_get20')

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
