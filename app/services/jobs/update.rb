module Jobs
  class Update
    include Common

    def call(job, params)
      return false unless job.update(whitelist(params))

      job.set_cost

      if job.quote_available? && job.quote_changed?
        notify_quote_changed(job)
        schedule_followup_email(job)
      end

      job.save

      job
    end
  end
end
