require 'capistrano/ext/multistage'
require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano-resque'

default_run_options[:pty] = true
ssh_options[:paranoid]    = false

set :stages,          %w(staging production)
set :default_stage,   "staging"
set :scm,             "git"
set :user,            "rails"
# set :runner,        "jwwalls"
set :use_sudo,        false
set :deploy_via,      :remote_cache
set :rvm_ruby_string, "2.0.0"
set :rvm_type,        :user
set :normalize_asset_timestamps, false

task :configure, roles: :app do
  commands = <<-EOF
    cp #{shared_path}/config/database.yml #{release_path}/config/database.yml;
    ln -s #{shared_path}/config/unicorn.rb #{release_path}/config/unicorn.rb;
  EOF
    # ln -s #{shared_path}/config/environment_variables.rb #{release_path}/config/environment_variables.rb
  run commands
end

namespace :deploy do
  def unicorn_running
    "[ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]"
  end

  def start_unicorn
    "cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  end

  task :restart do
    run "if #{unicorn_running}; then kill -USR2 `cat #{unicorn_pid}`; else #{start_unicorn}; fi"
  end
  task :start do
    run start_unicorn
  end
  task :stop do
    run "if #{unicorn_running}; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end

before  'deploy:finalize_update', 'configure'
after   'deploy:update', 'deploy:migrate'

# resque
after 'deploy:start', 'resque:start'
after 'deploy:stop', 'resque:stop'
after 'deploy:restart', 'resque:restart'

role :resque_worker,    domain
role :resque_scheduler, domain

set :workers, { '*' => 1 }
