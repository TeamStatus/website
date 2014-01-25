module ApplicationHelper

	def standalone
		ENV['STANDALONE'] == 'true'
	end

	def user_id
		return session[:user_id]
	end

	def base_path
		path = URI(ENV['CONSOLE_URL']).path
		if path.empty?
			'/'
		else
			path
		end
	end

end
