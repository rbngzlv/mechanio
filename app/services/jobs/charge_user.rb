module Jobs
  class ChargeUser
    def initialize(job)
      @job = job
    end

    def call
      result = Payments::ChargeUser.new(@job).call

      Jobs::ApplyGet20Discount.new(@job).call if result

      result
    end
  end
end
