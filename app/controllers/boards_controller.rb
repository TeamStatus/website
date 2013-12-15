class BoardsController < ApplicationController
	def index
		@boards = @user.boards
	end
end
