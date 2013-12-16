class AsyncDeviseMailer < Devise::Mailer
  include Resque::Mailer
end
