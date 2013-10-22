module MailerAliasMethods
  def mail_deliveries
    ActionMailer::Base.deliveries
  end

  def last_delivery
    mail_deliveries.last
  end
end

RSpec.configure do |config|
  config.before :each do
    AdminMailer.any_instance.stub(:all_admins).and_return(['admin@example.com'])
  end
end
