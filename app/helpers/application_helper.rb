module ApplicationHelper

	def standalone
		ENV['STANDALONE'] == 'true'
	end

	def user_id
		return session[:user_id]
	end

	def base_path
		URI(ENV['CONSOLE_URL']).path
	end

end
