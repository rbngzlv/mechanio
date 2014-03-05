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
    ln -s #{shared_path}/config/.env #{release_path}/.env
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

namespace :resque do
  desc "Quit running Resque workers"
  task :stop do
    run "if [ -e #{current_path}/tmp/pids/resque_work_1.pid ]; then \
      for f in `ls #{current_path}/tmp/pids/resque_work*.pid`; do \
        echo `cat $f`; \
        if [ ! -z `cat $f` ] && ps -p `cat $f`; then \
          kill -s #{resque_kill_signal} `cat $f` && rm $f; \
        else \
          rm $f \
        ;fi \
      ;done \
    ;fi"
  end
end

before  'deploy:finalize_update', 'configure'
after   'deploy:update', 'deploy:migrate'

# Stop resque before assets precompilation to avoid out of memory errors
before 'deploy:finalize_update', 'resque:stop'

after 'deploy:start', 'resque:start'
after 'deploy:stop', 'resque:stop'
after 'deploy:restart', 'resque:restart'

set :resque_environment_task, true
set :workers, { '*' => 1 }
