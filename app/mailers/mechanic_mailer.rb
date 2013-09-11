class MechanicMailer < ActionMailer::Base
  default from: "no-replay@mechanio.com"

  def registration_note(mechanic)
    @mechanic = mechanic
    mail(to: @mechanic.email, subject: 'Thnx for ur registration')
  end
end
