class JobService

  def initialize(job)
    @job = job
  end

  def complete
    @job.complete!

    @job.mechanic.update_job_counters

    [UserMailer, AdminMailer].each do |mailer|
      mailer.job_completed(@job.id).deliver
    end
  end
end
