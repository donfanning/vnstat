# for updating the developer's staging server

role :web, "sirius"                          # Your HTTP server, Apache/etc
role :app, "sirius"                          # This may be the same as your `Web` server
role :db,  "sirius", :primary => true # This is where Rails migrations will run

set :deploy_to, "/media/blue2/webapps/#{application}"

after "deploy:update_code", "deploy:migrate"