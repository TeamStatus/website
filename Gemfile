source 'https://rubygems.org'
ruby '2.2.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'

# Google Analytics
gem 'rack-google-analytics'

# Authentication
gem 'devise'
gem 'devise-encryptable'
gem 'devise_invitable'
gem 'omniauth-google-oauth2'
gem 'omniauth-bitbucket'
gem 'omniauth-github'
gem 'omniauth-facebook'
gem 'omniauth-linkedin'
gem 'omniauth-twitter'
gem 'koala'
gem 'gravtastic'

# Database
gem 'pg'
gem 'sequel'

# Scheduling
gem 'sidekiq'
gem 'sidetiq'
gem 'sinatra', '>= 1.3.0', :require => nil

# Smart ENV management
gem 'figaro'

gem 'websocket-rails'

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'compass-rails'

# Views
gem 'angularjs-rails'
gem 'angular-ui-bootstrap-rails'
gem 'less-rails'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'jquery-rails'
gem 'rickshaw_rails'

gem 'haml-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Mails
gem 'intercom-rails'
gem 'mandrill-api', :require => "mandrill"

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
	gem 'minitest'
	gem 'erb2haml'

	gem 'spork', '~>1.0.0rc'
	gem 'factory_girl_rails'
	gem 'database_cleaner'
	gem 'capybara'
	gem 'capybara-screenshot'
	gem 'rspec-rails'
	gem 'selenium-webdriver'
	gem "rack_session_access"

	gem 'capistrano'
	gem 'capistrano-rails'
	gem 'capistrano-bundler'
	gem 'capistrano-bower'
	gem 'capistrano-npm'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
gem 'unicorn'

# Error reporting
gem "bugsnag"

# Use debugger
# gem 'debugger', group: [:development, :test]
