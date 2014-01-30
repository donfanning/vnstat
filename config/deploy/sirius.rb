# for updating the developer's staging server
set :stage, :sirius

set :rails_relative_url_root, "/#{fetch(:application)}"
set :rails_env, 'production'

role :web, "sirius"                          # Your HTTP server, Apache/etc
role :app, "sirius"                          # This may be the same as your `Web` server
role :db,  "sirius", :primary => true # This is where Rails migrations will run

set :deploy_to, "/media/blue2/webapps/#{fetch(:application)}"

#after "deploy:update_code", "deploy:migrate"
