module Ajax
	class BoardsController < ApplicationController
		before_action :load_user

		def index
			@boards = @user.boards
		end

		private
			def load_user
				@user = ::User.find("5295063b32328cf35d000001")
			end
	end
end