require "capistrano/ext/multistage"
require "rvm/capistrano"
require "bundler/capistrano"

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

  namespace :assets do
    task :precompile, :roles => :web do
      from = source.next_revision(current_revision)
      # if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ lib/assets/ app/assets/ | wc -l").to_i > 0
        run_locally("rake assets:clean && rake assets:precompile")
        run_locally "cd public && tar -jcf assets.tar.bz2 assets"
        top.upload "public/assets.tar.bz2", "#{shared_path}", :via => :scp
        run "cd #{shared_path} && tar -jxf assets.tar.bz2 && rm assets.tar.bz2"
        run_locally "rm public/assets.tar.bz2"
        run_locally("rake assets:clean")
      # else
      #   logger.info "Skipping asset precompilation because there were no asset changes"
      # end
    end

    task :symlink, roles: :web do
      run ("rm -rf #{latest_release}/public/assets &&
            mkdir -p #{latest_release}/public &&
            mkdir -p #{shared_path}/assets &&
            ln -s #{shared_path}/assets #{latest_release}/public/assets")
    end
  end
end

before "deploy:finalize_update", "configure"
after "deploy:update", "deploy:migrate"

before 'deploy:finalize_update', 'deploy:assets:symlink'
after 'deploy:update_code', 'deploy:assets:precompile'
