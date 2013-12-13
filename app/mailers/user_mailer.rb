class UserMailer < AsyncMailer

  def job_pending(job)
    @job = job
    mail subject: 'Thanks for requesting a quote', to: job.user.email
  end

  def job_estimated(job)
    @job = job
    mail subject: "We've got a quote for your #{job.car.display_title}", to: job.user.email
  end

  def job_assigned(job)
    @job = job
    mail subject: 'Your booking with Mechanio is confirmed', to: job.user.email
  end

  def job_quote_changed(job)
    @job = job
    mail subject: "Your appointment for your #{job.car.display_title} has been updated", to: job.user.email
  end
end
