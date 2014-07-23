module Jobs
  class ApplyGive20Discount

    def initialize(job)
      @job = job
      @invitation = job.user.invitation
    end

    def call
      return false unless referred_user? && has_no_discount_yet?

      discount = Discount.create(title: '$20', discount_type: 'amount', discount_value: 20, channel: 'give20_get20')

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
