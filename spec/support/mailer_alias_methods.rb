module MailerAliasMethods
  def mail_deliveries
    ActionMailer::Base.deliveries
  end
end

RSpec.configure do |c|
  c.include MailerAliasMethods
end
