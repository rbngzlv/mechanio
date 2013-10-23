class MechanicMailer < ActionMailer::Base
  def registration_note(mechanic)
    @mechanic = mechanic
    mail to: @mechanic.email, subject: 'Welcome to Mechanio'
  end

  def job_assigned(job)
    @job = job
    mail to: job.mechanic.email, subject: 'You got a new job'
  end
end
