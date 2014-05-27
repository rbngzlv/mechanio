class MechanicCompleteJobService

  def initialize(job)
    @job = job
  end

  def perform
    @job.completed_at = Time.now
    @job.complete!

    @job.mechanic.update_job_counters

    UserMailer.async.job_completed(@job.id)
    UserMailer.async.leave_feedback(@job.id)
    AdminMailer.async.job_completed(@job.id)
  end
end
