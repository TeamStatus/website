class ConsoleController < ApplicationController
	def index
		@boards = @user.boards
	end
end