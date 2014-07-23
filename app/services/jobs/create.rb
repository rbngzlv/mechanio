module Jobs
  class Create
    include Common

    def call(user = nil, params)
      user ? create(user, params) : create_temporary(params)
    end


    private

    def create(user, params)
      job = Job.create(whitelist(params).merge(user: user))

      Jobs::ApplyGive20Discount.new(job).call

      job.set_cost
      notify_new_job(job)
      job
    end

    def create_temporary(params)
      job = build_temporary(whitelist(params))
      raise ActiveRecord::RecordInvalid, job unless job.valid?

      job = build_temporary(serialized_params: params)
      job.save(validate: false)
      job
    end

    def build_temporary(params)
      job = Job.new(params)
      job.skip_user_validation = true
      job.car.skip_user_validation = true if job.car
      job.status = 'temporary'
      job
    end
  end
end
