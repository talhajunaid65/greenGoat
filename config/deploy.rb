# config valid for current version and patch releases of Capistrano
lock "~> 3.12.1"

# Change these
server '3.84.100.107', roles: [:web, :app, :db], primary: true

set :repo_url, 'git@github.com:talhajunaid63/greenGoat.git'
set :user, 'ubuntu'
set :application, 'greenGoat'
set :rails_env, :production
set :branch, :master

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/var/www/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/greenGoat-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log,  "#{shared_path}/log/puma_access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false  # Change to true if using ActiveRecord

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
set :keep_releases, 5

## Linked Files & Directories (Default None):
set :linked_files, %w{config/master.key}
set :bundle_binstubs, nil
set :linked_dirs,  %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system storage}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      if fetch(:stage) == (:staging || 'staging')
        if `git rev-parse HEAD` != `git rev-parse origin/staging`
          puts "WARNING: HEAD is not the same as origin/staging"
          puts "Run `git push` to sync changes."
          exit
        end
      elsif `git rev-parse HEAD` != `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke!('puma:restart')
    end
  end

  before :starting, :check_revision
  after  :finishing, :compile_assets
  after  :finishing, :cleanup
  after  :finishing, :restart
end
