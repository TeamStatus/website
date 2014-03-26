class PublicBoardsController < ApplicationController
	include BoardsHelper

	skip_before_filter :authenticate_user!
	before_action :set_board

	def show
		@editing = false
		render 'show', :layout => false
	end

	private

	def set_board
		@board = Board.where(public_id: params[:publicId]).first
		raise ActionController::RoutingError.new('Not Found') if @board.nil?
	end

end
