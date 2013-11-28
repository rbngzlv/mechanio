class MechanicMailer < ActionMailer::Base
  def registration_note(mechanic)
    @mechanic = mechanic
    mail to: @mechanic.email, subject: 'Welcome to Mechanio'
  end

  def job_assigned(job)
    @job = job
    mail to: job.mechanic.email, subject: 'Congratulations, you’ve been scheduled a job.'
  end
end
