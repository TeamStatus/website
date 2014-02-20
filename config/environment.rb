# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
ConsoleRails::Application.initialize!

%w{COOKIE_SECRET COOKIE_NAME MONGODB_URL CONSOLE_SECRET ENCRYPTED_FIELDS_SALT ENCRYPTED_FIELDS_PASSWORD CONSOLE_URL}.each do |var|
  abort("missing env var: please set #{var}") unless ENV[var]
end

unless Rails.env.standalone?
	%w{GOOGLE_KEY GOOGLE_SECRET BOARDS_URL}.each do |var|
	  abort("missing env var: please set #{var}") unless ENV[var]
	end

	ENV['BOARDS_URL'] = ENV['BOARDS_URL'].chomp('/')
else
	ENV['BOARDS_URL'] = 'http://127.0.0.1:57518'
end

ENV['COOKIE_DOMAIN'] ||= ''

%w{GOOGLE_ANALYTICS INTERCOM_APP_ID INTERCOM_KEY MIXPANEL_APP_ID}.each do |var|
	puts "missing env var (some features will be disabled): #{var}" unless ENV[var]
end