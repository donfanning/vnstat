source 'https://rubygems.org'

gem 'rails'
gem 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.

gem 'sass-rails'
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platforms => :ruby

gem 'uglifier'

gem 'jquery-rails'

gem "bootstrap-sass"
gem "font-awesome-sass"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem 'quiet_assets'                            # quieter logging
  gem 'thin'                                    # quieter log than webrick
  gem "capistrano", '~> 3.0', require: false    # deployment
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
end

gem "dalli"                                     # memcache

gem 'figaro'