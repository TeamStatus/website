Figaro.require_keys("COOKIE_SECRET", "COOKIE_NAME", "MAILCHIMP_KEY", "MAILCHIMP_LIST")

ENV['COOKIE_DOMAIN'] ||= ''

%w{GOOGLE_ANALYTICS GOOGLE_KEY GOOGLE_SECRET INTERCOM_APP_ID INTERCOM_KEY INTERCOM_SECRET MIXPANEL_APP_ID}.each do |var|
	puts "missing env var (some features will be disabled): #{var}" unless ENV[var]
end