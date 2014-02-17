class SourcesController < ApplicationController
	include BoardsHelper

	before_action :set_source, only: [:show, :edit, :update, :destroy]

	def tap
		boards_engine.tap(params[:id], ActiveSupport::JSON.decode request.body)
	end

end
