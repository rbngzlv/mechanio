class MechanicCompleteJobService

  def initialize(job)
    @job = job
  end

  def perform
    @job.completed_at = Time.now
    @job.complete!

    @job.mechanic.update_job_counters

    [UserMailer, AdminMailer].each do |mailer|
      mailer.job_completed(@job.id).deliver
    end
  end
end
