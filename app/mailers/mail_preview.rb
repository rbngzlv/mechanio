class MailPreview < MailView

  def devise_confirmation_instructions
    user = User.first
    Devise::Mailer.confirmation_instructions(user)
  end

  def devise_reset_password
    user = User.first
    Devise::Mailer.reset_password_instructions(user)
  end

  def user_job_quote_changed
    job = Job.estimated.first
    UserMailer.job_quote_changed(job.id)
  end

  def user_job_assigned
    job = Job.assigned.first
    UserMailer.job_assigned(job.id)
  end

  def user_job_completed
    job = Job.completed.first
    UserMailer.job_completed(job.id)
  end

  def user_leave_feedback
    job = Job.completed.first
    UserMailer.leave_feedback(job.id)
  end


  # Mechanic

  def mechanic_registration_note
    mechanic = Mechanic.first
    MechanicMailer.registration_note(mechanic.id, 'PASSWORD')
  end

  def mechanic_job_assigned
    job = Job.assigned.first
    MechanicMailer.job_assigned(job.id)
  end

  def mechanic_job_quote_changed
    job = Job.assigned.first
    MechanicMailer.job_quote_changed(job.id)
  end

end
