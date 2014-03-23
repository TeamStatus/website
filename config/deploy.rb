# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'teamstatus'
set :repo_url, 'git@bitbucket.org:teamstatus/teamstatus.git'
set :git_shallow_clone, 1

set :ssh_options, { :forward_agent => true }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/teamstatus.tv'

# Default value for :pty is false
set :pty, true

set :bundle_binstubs, -> { shared_path.join('stubs') }
set :bundle_env_variables, { nokogiri_use_system_libraries: 1 }
set :figaro_path, -> { fetch(:deploy_to) + '/configuration' }

set :npm_target_path, -> { release_path.join('lib/pullers') }
set :npm_flags, '--production --silent'           # default
set :npm_roles, :all

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets}

set :default_env, {
  path: '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'
}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      # execute :sv, 2, "/home/deployer/service/teamstatus"
      execute :sv, 'restart', "/home/deployer/service/sidekiq"
      execute :sv, 'restart', "/home/deployer/service/websocket"
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

before "bundler:install", "figaro:symlink"
