# This file is used by Rack-based servers to start the application.
require 'intercom'
require 'rack/cors'

if ENV['GOOGLE_ANALYTICS']
	# Google Analytics: UNCOMMENT IF DESIRED, THEN ADD YOUR OWN ACCOUNT INFO HERE!
	require 'rack/google-analytics'
	use Rack::GoogleAnalytics, :tracker => ENV['GOOGLE_ANALYTICS']
end

if ENV['INTERCOM_APP_ID'] and ENV['INTERCOM_KEY']
	Intercom.app_id = ENV['INTERCOM_APP_ID']
	Intercom.api_key = ENV['INTERCOM_KEY']
end

use Rack::Cors, :debug => false do
  allow do
    origins ENV['BOARDS_URL']

    resource '/*.json',
        :methods => [:get, :post, :put, :delete],
        :headers => :any,
        :max_age => 600,
        :credentials => true
  end
end

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
