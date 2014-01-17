module CorsHandler
	extend ActiveSupport::Concern

	included do
		before_filter :allow_cors unless Rails.env.standalone?
	end

	protected
		def allow_cors
			headers['Access-Control-Max-Age'] = '3600' # seconds (1h)
		  headers["Access-Control-Allow-Origin"] = ENV['BOARDS_URL']
		  headers["Access-Control-Allow-Methods"] = %w{GET POST PUT DELETE}.join(",")
		  headers['Access-Control-Allow-Credentials'] = 'true'
		  headers["Access-Control-Allow-Headers"] =
		    %w{Origin Accept Content-Type X-Requested-With X-XSRF-Token}.join(",")

		  head(:ok) if request.request_method == "OPTIONS"
		end
end