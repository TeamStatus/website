class PartialsController < ApplicationController

	def show
		render partial: params[:partial_id]
	end

	def widget_js
		render :layout => false, :file => Rails.root.join('integrations', params[:widget_id], 'config.js'), :content_type => 'application/javascript'
	end

	def widget
		render :layout => false, :file => Rails.root.join('integrations', params[:widget_id], 'config.html'), :content_type => 'text/html'
	end

end
