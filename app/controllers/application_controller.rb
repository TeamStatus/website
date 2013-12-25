class ApplicationController < ActionController::Base
	include ApplicationHelper
	include CorsHandler

	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception, unless: :options_request?

	before_filter :load_user
	after_filter :set_csrf_cookie_for_ng

	private

		def load_user
			if standalone
				@user = ::User.where({ :email => "admin@localhost" }).first
				if @user.nil?
					@user = ::User.create!({:email => "admin@localhost", :fullName => "Administrator", :callingName => "admin" })
				end
			elsif not user_id.nil?
				@user = ::User.where({ :id => user_id }).first
				if @user.nil?
					redirect_to(:controller => 'login') and return false
				end
			else
				redirect_to(:controller => 'login') and return false
			end
		end

		def set_csrf_cookie_for_ng
			cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
		end

		def verified_request?
			super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
		end

		def options_request?
	  	request.request_method == "OPTIONS"
	 	end
end
