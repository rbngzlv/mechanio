require 'resque/tasks'
require 'resque_scheduler/tasks'

namespace :resque do
  task setup: :environment do
  end
end
