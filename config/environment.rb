# Load the Rails application.
require File.expand_path('../application', __FILE__)
require 'intercom'

# Initialize the Rails application.
ConsoleRails::Application.initialize!

%w{COOKIE_SECRET COOKIE_NAME GOOGLE_KEY GOOGLE_SECRET BOARDS_URL MONGODB_URL CONSOLE_SECRET ENCRYPTED_FIELDS_SALT ENCRYPTED_FIELDS_PASSWORD}.each do |var|
  abort("missing env var: please set #{var}") unless ENV[var]
end

ENV['BOARDS_URL'] = ENV['BOARDS_URL'].chomp('/')
ENV['COOKIE_DOMAIN'] ||= ''

%w{MAILCHIMP_KEY MAILCHIMP_LIST GOOGLE_ANALYTICS REDISCLOUD_URL SPLIT_PASSWORD SPLIT_USER INTERCOM_APP_ID INTERCOM_KEY MIXPANEL_APP_ID}.each do |var|
	puts "missing env var (some features will be disabled): #{var}" unless ENV[var]
end

if ENV['INTERCOM_APP_ID'] and ENV['INTERCOM_KEY']
	Intercom.app_id = ENV['INTERCOM_APP_ID']
	Intercom.api_key = ENV['INTERCOM_KEY']
end
