class MechanicMailer < ActionMailer::Base
  def registration_note(mechanic)
    @mechanic = mechanic
    mail(to: @mechanic.email, subject: 'Thnx for ur registration')
  end
end
