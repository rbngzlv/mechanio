module Jobs
  class Cancel

    def initialize(job)
      @job = job
    end

    def call
      return false if @job.cancelled?

      @job.cancel!

      send_notifications

      true
    end

    def send_notifications
      # UserMailer.async.job_cancelled(@job.id)
      # MechanicMailer.async.job_cancelled(@job.id)
    end
  end
end
