# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Mechanio::Application.initialize!

ActionMailer::Base.default from: 'no-replay@mechanio.com'
