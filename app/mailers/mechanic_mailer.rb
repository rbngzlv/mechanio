class MechanicMailer < AsyncMailer
  def registration_note(mechanic_id)
    @mechanic = Mechanic.find(mechanic_id)
    mail to: @mechanic.email, subject: 'Welcome to Mechanio! What you need to know as a Mechanio Mobile Mechanic'
  end

  def job_assigned(job_id)
    @job = Job.find(job_id)
    mail to: @job.mechanic.email, subject: 'Congratulations, you’ve been scheduled a job.'
  end
end
