class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	before_action :load_user
	after_filter :set_csrf_cookie_for_ng

	protected
		def standalone
			ENV['STANDALONE'] == "true"
		end

		def user_id
			return session[:user_id]
		end

	private
		def load_user
			if standalone
				@user = ::User.where({ :email => "admin@localhost" }).first
				if @user.nil?
					@user = ::User.create!({:email => "admin@localhost", :fullName => "Administrator", :callingName => "admin" })
				end
			elsif not user_id.nil?
				@user = ::User.find(user_id)
				unless @user.exists?
					redirect_to('http://teamstatus.tv/beta') and return false
				end
			else
				redirect_to('http://teamstatus.tv/beta') and return false
			end
		end

		def set_csrf_cookie_for_ng
			cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
		end

		def verified_request?
			super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
		end
end
