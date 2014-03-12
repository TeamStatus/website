module Integrations
	class PartialsController < ApplicationController

		skip_before_filter :load_user
		before_filter :load_package_json
		before_filter :set_widget

		def configuration
			render template: 'integrations/' + params[:widget_id] + '/config', layout: false
		end

		def html
			render template: 'integrations/' + @widget + '/widget', layout: false
		end

		private

		def load_package_json
			packageFile = Rails.root.join('app', 'views', 'integrations', params[:widget_id], 'package.json')
			if File.exists? packageFile
				@packageJson = JSON.parse File.read packageFile
			else
				@packageJson = nil
			end
		end

		def set_widget
			@widget = params[:widget_id]
			if @packageJson && @packageJson['widget']
				@widget = @packageJson['widget']
			end
		end
	end
end