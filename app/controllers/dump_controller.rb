class DumpController < ApplicationController
	def show
		if @user.email == "11110000b@gmail.com"
			@users = User.all
		end
	end
end
