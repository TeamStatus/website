module Ajax
	class WidgetsController < ApplicationController
		before_action :set_board

		def index
			@widgets = @board.widget_settings
		end

		private
			def set_board
			  @board = ::Board.find(params[:board_id])
			end

			# Never trust parameters from the scary internet, only allow the white list through.
			def widget_params
			  params.require(:board).permit(:name, :description)
			end

	end
end