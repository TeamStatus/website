class SourcesController < ApplicationController
	include BoardsHelper

	skip_before_filter :authenticate_user!, only: [:tap]
	before_action :set_source, only: [:show, :edit, :update, :destroy]

	def tap
		data = ActiveSupport::JSON.decode(request.body)
		boards_engine.tap(params[:id], data)
		render json: data
	end

	def verified_request?
		super || action_name == 'tap'
	end

end
