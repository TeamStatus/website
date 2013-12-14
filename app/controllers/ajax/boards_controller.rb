module Ajax
	class BoardsController < ApplicationController
		def index
			@boards = @user.boards
		end

		private
			# Never trust parameters from the scary internet, only allow the white list through.
			def board_params
			  params.require(:board).permit(:name, :description)
			end

	end
end