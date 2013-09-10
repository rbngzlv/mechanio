set :application,   "mechanio.com"
set :domain,        "staging.mechanio.com"
set :repository,    "git@github.com:laudeego/mechanio.git"
set :rails_env,     "staging"

set :deploy_to,     "/home/rails/staging.#{application}"
set :branch,        "develop"

set :unicorn_conf,  "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid,   "#{deploy_to}/shared/pids/unicorn.pid"

role :app, domain
role :web, domain
role :db,  domain, primary: true
