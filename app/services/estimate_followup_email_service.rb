class EstimateFollowupEmailService
  @queue = 'mailer'

  def self.schedule(job_id)
    Resque.enqueue_in(2.days, EstimateFollowupEmailService, job_id)
  end

  def self.perform(job_id)
    @job = Job.find(job_id)

    if @job.estimated?
      UserMailer.estimate_followup(@job.id).deliver!
    end
  end
end
