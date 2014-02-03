class BoardsController < ApplicationController
	include BoardsHelper

	before_action :set_board, only: [:show, :update, :destroy]

	def index
		@boards = @user.boards
		unless @boards.exists?
			board = @user.boards.build({ :name => "First board!" })
			board.jobs.build({:jobId => 'static-html', :widgetSettings => { :title => "Welcome!",
				:html => '<p>This is your first boad!</p>
<p>Use menu on top  to add widgets!</p>
<p>If you need any help please <a href="mailto:pawel@teamstatus.tv">contact me</a></p>
<p>Sincerely, Pawel Niewiadomski, CEO</p>' }})
			board.save
			redirect_to board_edit_url(board)
		end

		def show
		end

		def new
		end

		def create
		end
	end

	private

	def set_board
		@board = @user.boards.find(params[:id])
	end

end
