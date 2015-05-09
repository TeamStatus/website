module Embedable
	class TapsController < ApplicationController
		skip_before_filter :authenticate_user!

		layout 'embedable'

		def show
		end
	end
end