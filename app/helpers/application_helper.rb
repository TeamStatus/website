module ApplicationHelper

	def standalone
		ENV['STANDALONE'] == 'true'
	end

	def user_id
		return session[:user_id]
	end

	def base_url
		ENV['CONSOLE_URL']
	end

	def base_path
		URI(base_url).path
	end

end
