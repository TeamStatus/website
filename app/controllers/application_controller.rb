class ApplicationController < ActionController::Base
	include ApplicationHelper

	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	before_filter :authenticate_user!

	after_filter :set_csrf_cookie_for_ng

	private

	def set_csrf_cookie_for_ng
		if protect_against_forgery?
			cookies['XSRF-TOKEN'] = {
				value: form_authenticity_token,
				domain: ENV['COOKIE_DOMAIN']
			}
		end
	end

	def verified_request?
		super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
	end

	def after_sign_in_path_for(resource)
		boards_path
	end
end
