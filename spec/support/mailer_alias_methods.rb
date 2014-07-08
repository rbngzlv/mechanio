module MailerAliasMethods
  def mail_deliveries
    ActionMailer::Base.deliveries
  end

  def reset_mail_deliveries
    ActionMailer::Base.deliveries = []
  end

  def last_delivery
    mail_deliveries.last
  end

  def verify_emails_sent(emails)
    mail_deliveries.count.should eq emails.length

    emails.each do |subject, to|
      delivery = mail_deliveries.find { |m| m.subject == subject }
      delivery.to.should eq Array(to)
    end
  end
end

RSpec.configure do |config|
  config.before :each do
    AdminMailer.any_instance.stub(:all_admins).and_return(['admin@example.com'])
  end
end
