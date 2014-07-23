module Jobs
  class Complete

    def initialize(job)
      @job = job
    end

    def call
      return false unless @job.can_complete?

      @job.completed_at = Time.now
      @job.complete!
      @job.save!

      @job.mechanic.update_job_counters

      enqueue_payment(@job)

      send_notifications
    end

    private

    def enqueue_payment(job)
      ChargeUserWorker.enqueue(job.id)
    end

    def send_notifications
      UserMailer.async.job_completed(@job.id)
      UserMailer.async.leave_feedback(@job.id)
      AdminMailer.async.job_completed(@job.id)

      if @job.user.past_jobs.count == 1
        UserMailer.async.first_job_completed(@job.id)
      end
    end
  end
end
