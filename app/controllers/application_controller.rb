class ApplicationController < ActionController::Base
	include ApplicationHelper

	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

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
		if protect_against_forgery?
			cookies['XSRF-TOKEN'] = {
				value: form_authenticity_token,
				domain: ENV['COOKIE_DOMAIN']
			}
		end
	end

	def verified_request?
		super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
	end

end
