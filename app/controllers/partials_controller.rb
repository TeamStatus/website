class PartialsController < ApplicationController

	def show
		render partial: params[:partial_id]
	end

end
