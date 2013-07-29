# heavily influenced by "a capistrano rails guide" by jonathan rochkind"
# https://github.com/capistrano/capistrano/wiki/2.x-Multistage-Extension

set :stage, %w(sirius sbc)
set :default_stage, "sirius"

require 'capistrano/ext/multistage'

set :application, "vnstat"
set :repository,  "https://github.com/mfrederickson/vnstat.git"
set :asset_env, "#{asset_env} RAILS_RELATIVE_URL_ROOT=/#{application}"

#set :user, "www-data"
#set :group, "www-data"

set :use_sudo, false

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

task :uname do
  run "uname -a"
end

default_run_options[:pty] = true

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

#after "deploy:update_code", "custom:config"
# move migrate to production one since we dont want to run this when updating the kiosks
#after "deploy:update_code", "deploy:migrate"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# preserve the nondeployed app config
namespace :custom do
  task :config, :roles => :app do
    run <<-END
      ln -nfs #{shared_path}/system/application.yml #{release_path}/config/application.yml
    END
  end
end

require "bundler/capistrano"
