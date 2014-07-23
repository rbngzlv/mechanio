module Jobs
  class ApplyGive20Discount

    def initialize(job)
      @job = job
    end

    def call
      return false unless referred_user? && first_job?

      discount = Discount.create(title: '$20', discount_type: 'amount', discount_value: 20)
      # get  = Discount.create(title: 'Get $20 discount', discount_type: 'amount', discount_value: 20)

      Jobs::ApplyDiscount.new(@job, discount.code).call
    end


    private

    def first_job?
      @job.user.jobs.count == 1
    end

    def referred_user?
      @job.user.referred_by.present?
    end
  end
end
