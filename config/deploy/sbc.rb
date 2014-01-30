# for updating the developer's staging server
set :stage, :sbc

role :web, "office.soldotnabiblechapel.org"                     # Your HTTP server, Apache/etc
role :app, "office.soldotnabiblechapel.org"                     # This may be the same as your `Web` server
role :db,  "office.soldotnabiblechapel.org", :primary => true 	# This is where Rails migrations will run

set :deploy_to, "/var/webapps/#{application}"

after "deploy:update_code", "deploy:migrate"
