class MechanicCompleteJobService

  def initialize(job)
    @job = job
  end

  def perform
    @job.completed_at = Time.now
    @job.complete!

    @job.mechanic.update_job_counters

    UserMailer.job_completed(@job.id).deliver
    UserMailer.leave_feedback(@job.id).deliver
    AdminMailer.job_completed(@job.id).deliver
  end
end
