class PublicBoardsController < ApplicationController
	include BoardsHelper

	skip_before_filter :load_user
	before_action :set_board

	def show
		@editing = false
		render 'show', :layout => false
	end

	private

	def set_board
		@board = Board.where(publicId: params[:publicId]).first
	end

end
