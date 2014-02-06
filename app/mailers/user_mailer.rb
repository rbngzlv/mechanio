class UserMailer < AsyncMailer

  def job_pending(job_id)
    @job = Job.find(job_id)
    mail subject: 'Thanks for requesting a quote', to: @job.user.email
  end

  def job_estimated(job_id)
    @job = Job.find(job_id)
    mail subject: "We've got a quote for your #{@job.car.display_title}", to: @job.user.email
  end

  def job_assigned(job_id)
    @job = Job.find(job_id)
    mail subject: 'Your booking with Mechanio is confirmed', to: @job.user.email
  end

  def job_quote_changed(job_id)
    @job = Job.find(job_id)
    mail subject: "Your appointment for your #{@job.car.display_title} has been updated", to: @job.user.email
  end

  def job_cancelled(job_id)
    @job = Job.find(job_id)
    mail subject: 'Your job cancelled from mechanic', to: @job.user.email
  end
end
