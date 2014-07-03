class UserMailer < ActionMailer::Base
  extend AsyncMailer::Mailer

  def job_pending(job_id)
    @job = Job.find(job_id)
    mail subject: 'Thanks for requesting a quote', to: @job.user.email
  end

  def job_estimated(job_id)
    @job = Job.find(job_id)
    mail subject: "We've got a quote for your #{car_title}", to: @job.user.email
  end

  def estimate_followup(job_id)
    @job = Job.find(job_id)
    mail subject: "Can I help you with your #{car_title}?", to: @job.user.email
  end

  def job_assigned(job_id)
    @job = Job.find(job_id)
    mail subject: 'Your booking with Mechanio is confirmed', to: @job.user.email
  end

  def job_reassigned(job_id)
    @job = Job.find(job_id)
    mail subject: 'Your job assigned to a different mechanic', to: @job.user.email
  end

  def job_quote_changed(job_id)
    @job = Job.find(job_id)
    mail subject: "Your appointment for your #{car_title} has been updated", to: @job.user.email
  end

  def job_completed(job_id)
    @job = Job.find(job_id)
    receipt = UsersJobReceipt.new(@job)
    attachments["Mechanio_#{@job.uid}"] = { mime_type: 'application/pdf', content: receipt.to_pdf, parts_order: ['text/html', 'application/pdf'] }
    mail subject: "Your Mechanio Receipt is now ready to view", to: @job.user.email
  end

  def leave_feedback(job_id)
    @job = Job.find(job_id)
    mail subject: "How did #{mechanic_name} go?", to: @job.user.email
  end


  private

  def car_title
    @job.car.display_title
  end

  def mechanic_name
    @job.mechanic.first_name
  end
end
