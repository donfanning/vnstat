# for updating the developer's staging server
set :stage, :artemis2

set :rails_relative_url_root, "/#{fetch(:application)}"
set :rails_env, 'production'

role :web, "artemis2"                          # Your HTTP server, Apache/etc
role :app, "artemis2"                          # This may be the same as your `Web` server
role :db,  "artemis2", :primary => true # This is where Rails migrations will run

set :deploy_to, "/var/webapps/#{fetch(:application)}"

#after "deploy:update_code", "deploy:migrate"
