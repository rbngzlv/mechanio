require 'resque'
require 'resque_scheduler'

Resque::Mailer.excluded_environments = [:development, :test]
