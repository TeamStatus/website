module ApplicationHelper

	def user_id
		return session[:user_id]
	end

	def anonymous
		user_id.nil?
	end

	def base_path
		path = URI(ENV['CONSOLE_URL']).path
		if path.empty?
			'/'
		else
			path
		end
	end

	def body_class
    [controller_name, action_name].join('-')
  end

end
