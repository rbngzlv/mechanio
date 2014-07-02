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

      UserMailer.async.job_completed(@job.id)
      UserMailer.async.leave_feedback(@job.id)
      AdminMailer.async.job_completed(@job.id)
    end

    private

    def enqueue_payment(job)
      Resque.enqueue(PaymentService, job.user.id, job.id) unless Rails.env.test?
    end
  end
end
