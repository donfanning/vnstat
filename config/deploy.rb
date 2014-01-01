set :default_stage, "sirius"

set :application, "vnstat"
set :repo_url, "https://github.com/mfrederickson/vnstat.git"

#set :asset_env, "#{asset_env} RAILS_RELATIVE_URL_ROOT=/#{application}"

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# set :deploy_to, '/var/www/my_app'
# set :scm, :git

# set :format, :pretty
# set :log_level, :debug
set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

#after "deploy:assets:symlink", "custom:config"


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end

# preserve the nondeployed app config
namespace :custom do
  task :config do
    on roles(:app) do
      run <<-END
        ln -nfs #{shared_path}/system/application.yml #{release_path}/config/application.yml
      END
    end
  end
end
