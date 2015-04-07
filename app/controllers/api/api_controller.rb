module Api
	class ApiController < ApplicationController

		respond_to :json

		acts_as_token_authentication_handler_for User, fallback_to_devise: false

		skip_before_filter :verify_authenticity_token

		skip_before_filter :authenticate_user!

		before_filter :parse_request

		private

		def parse_request
			@json = JSON.parse(request.body.read) if request.method == 'POST' || request.method == 'PUT'
		end
	end
end