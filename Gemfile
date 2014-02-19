source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0.0'

# Integrations
gem 'integrations', :git => 'https://bitbucket.org/teamstatus/integrations.git', :branch => 'master'

# Google Analytics
gem 'rack-google-analytics'

# Authentication
gem 'oauth2'

# HTTP
gem 'httparty'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'compass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Database
gem 'moped', github: 'mongoid/moped'
gem 'mongoid', github: 'mongoid/mongoid'
gem 'mongoid_rails_migrations'
gem 'mongoid-encrypted-fields'
gem 'gibberish'
gem 'bson_ext'

# Logging to stdout by default
gem 'rails_stdout_logging'

# Mails
gem 'intercom-rails', '~> 0.2.24'
gem 'mandrill-api', :require => "mandrill"

# Views
gem 'haml-rails'
gem 'less-rails'
gem 'bootstrap-sass', '~> 3.0.3.0'
gem 'font-awesome-rails'
gem 'angularjs-rails'
gem 'angular-ui-bootstrap-rails'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
	# Monitoring
	gem 'newrelic_rpm'

	# Better heroku support (serving static files and logging to stdout)
	gem 'rails_12factor'
end

group :development, :test do
	gem 'spork', '~> 1.0rc'
	gem 'factory_girl_rails'
	gem 'database_cleaner'
	gem 'capybara'
	gem 'capybara-screenshot'
	gem 'rspec-rails'
	gem 'selenium-webdriver'

	# Smart ENV management
	gem 'figaro'
end

group :development do
	gem 'mongoid-shell', :github => 'pawelniewie/mongoid-shell', :branch => 'moped-2.0.0'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
