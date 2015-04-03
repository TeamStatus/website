module Api
	class ApiController < ApplicationController

		protect_from_forgery with: :null_session

		respond_to :json

		acts_as_token_authentication_handler_for User, fallback_to_devise: false

		before_filter :parse_request

		private

		def parse_request
			@json = JSON.parse(request.body.read)
		end
	end
end