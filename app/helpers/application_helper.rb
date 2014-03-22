module ApplicationHelper

	def user_id
		return session[:user_id]
	end

	def body_class
    [controller_name, action_name].join('-')
  end

end
