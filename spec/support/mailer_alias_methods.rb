module MailerAliasMethods
  def mail_deliveries
    ActionMailer::Base.deliveries
  end

  def last_delivery
    mail_deliveries.last
  end
end
