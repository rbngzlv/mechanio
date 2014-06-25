module Jobs
  class Complete

    def initialize(job)
      @job = job
    end

    def call
      return false unless @job.can_complete?

      @job.completed_at = Time.now
      @job.complete!

      @job.mechanic.update_job_counters

      UserMailer.async.job_completed(@job.id)
      UserMailer.async.leave_feedback(@job.id)
      AdminMailer.async.job_completed(@job.id)
    end
  end
end
