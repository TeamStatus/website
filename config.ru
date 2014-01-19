# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

class Helper
	include ApplicationHelper
end

map Helper.new.base_path do
	run Rails.application
end
