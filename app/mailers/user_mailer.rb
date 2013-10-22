class UserMailer < ActionMailer::Base

  def job_pending(job)
    @job = job
    mail subject: 'Quote requested', to: job.user.email
  end

  def job_estimated(job)
    @job = job
    mail subject: 'Job quote', to: job.user.email
  end

  def job_assigned(job)
    @job = job
    mail subject: 'Job assigned', to: job.user.email
  end

  def job_quote_changed(job)
    @job = job
    mail subject: 'Job quote updated', to: job.user.email
  end
end
