class MechanicMailer < ActionMailer::Base
  extend AsyncMailer::Mailer

  def registration_note(mechanic_id, mechanic_password)
    @mechanic = Mechanic.find(mechanic_id)
    @password = mechanic_password
    mail to: @mechanic.email, subject: 'Welcome to Mechanio Family!'
  end

  def job_assigned(job_id)
    @job = Job.find(job_id)
    mail to: @job.mechanic.email, subject: 'Congratulations, you\'ve been scheduled a job.'
  end

  def job_quote_changed(job_id)
    @job = Job.find(job_id)
    mail subject: "Your appointment for #{car_title} has been updated", to: @job.mechanic.email
  end


  private

  def car_title
    @job.car.display_title
  end
end
