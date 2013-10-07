# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'resque/tasks'

ROOT_PATH = File.expand_path("..", __FILE__)
load File.join(ROOT_PATH, 'lib/tasks/resque.rake')

Mechanio::Application.load_tasks
