class ConsoleController < ApplicationController
	def index
		redirect_to :controller => 'boards'
	end
end