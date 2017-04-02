#require 'capistrano/ext/multistage'
# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'Webx'
set :repo_url, 'https://server-deployer:gZdsjkR8EePxvmQ@github.com/michal55/WebX.git'
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH" }
# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/webx'
set :rbenv_ruby, '2.3.1'
# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
set :format, :airbrussh
set :format_options, truncate: false

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
#set :format_options, command_output: true, log_file: '/var/log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :stages, ["staging", "production"]
set :default_stage, "staging"

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end


namespace :deploy do

  desc "set up env"
  task :set_up_env do
    on roles(:app) do
      within "#{current_path}" do
        execute "export RAILS_ENV=\"#{fetch(:rails_env)}\""
      end
    end
  end

  desc "Bundler install"
  task :bundler_install do
    on roles(:app) do |host|
      within "#{current_path}" do
        execute :bundler, "install"
      end
    end
  end

  desc "migrate the database."
  task :db_migrate do
    on roles(:db) do
      within "#{current_path}" do
        execute :rake, "db:migrate RAILS_ENV='#{fetch(:stage)}'"
      end
    end
  end

  desc "create the database."
  task :db_create do
    on roles(:db) do
      within "#{current_path}" do
          execute :rake, "db:create RAILS_ENV='#{fetch(:stage)}'"
      end
    end
  end
  desc "rake precompile"
  task :rake_precompile do
    on roles(:web) do
      execute "cd #{fetch(:working_dir)}; $HOME/.rbenv/bin/rbenv exec bundle exec rake assets:precompile RAILS_ENV='#{fetch(:stage)}'"
    end
  end
  desc "create the database."
  task :db_test do
    on roles(:db) do
      within "#{current_path}" do
        unless remote_file_exists?('current/db/schema.rb')
          execute :db_create
        end
      end
    end
  end

  desc "restart unicorn"
  task :restart_unicorn do
    on roles(:web) do
      execute "/etc/init.d/#{fetch(:config_file)} stop; sleep 5; /etc/init.d/#{fetch(:config_file)} start"
    end
  end
  
  desc "Bundler install"
  task :bundler_install1 do
    on roles(:app) do |host|
      within "#{current_path}" do
        execute "cd #{fetch(:working_dir)}; $HOME/.rbenv/bin/rbenv exec bundle install RAILS_ENV='#{fetch(:stage)}'"
      end
    end
  end

  desc "Server setup"
  task :server_setup do
    on roles(:web) do |host|
      within "#{current_path}" do
        execute "cd #{fetch(:working_dir)}; rm -f /etc/nginx/sites-available/webx.conf; "\
		"rm -f /etc/init.d/unicorn-#{fetch(:application)}; "\
		"sed \"s/\\[server_name\\]/`hostname -A`/\" < config/nginx.conf | sed \"s/\\*\\.\\[server_name\\]/\\*\\.`hostname -A`/\"| sed \"s|\\[path_to_root_web\\]|`pwd`|\" > /etc/nginx/sites-available/webx.conf; "\
		"sed \"s|\\[APP_ROOT\\]|#{fetch(:working_dir)}|\" < config/unicorn.init | sed \"s/\\[APP_NAME\\]/#{fetch(:application)}/\" | sed \"s/\\[USER\\]/#{fetch(:user)}/\" > /etc/init.d/unicorn-#{fetch(:application)}; "\
		"chmod +x /etc/init.d/unicorn-#{fetch(:application)}; "\
		"/etc/init.d/unicorn-#{fetch(:application)} stop; "\
		"/etc/init.d/unicorn-#{fetch(:application)} start; "\
		"/etc/init.d/nginx restart;"
      end
    end
  end

  after 'deploy', 'deploy:set_up_env'
  after 'deploy:set_up_env', 'deploy:db_create'
  after 'deploy:db_create', 'deploy:db_migrate'
  after 'deploy:db_migrate', 'deploy:rake_precompile'
  after 'deploy:rake_precompile', 'deploy:restart_unicorn'
#  after 'deploy:rake_precompile', 'deploy:server_setup'

  after 'deploy:rake_precompile', 'resque:restart'
  after 'deploy:rake_precompile', 'resque:scheduler:restart'

end
