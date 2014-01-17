module ApplicationHelper

	def standalone
		Rails.env.standalone?
	end

	def user_id
		return session[:user_id]
	end
end
