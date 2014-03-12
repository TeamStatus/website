module BoardsHelper
	extend ActiveSupport::Concern

	def boards_base_url
		URI(ENV['BOARDS_URL'])
	end

	def board_public_url(board)
		url_params = {controller: 'public_boards', action: 'show', publicId: board.publicId, host: request.host, port: request.port, protocol: request.protocol}
		unless Rails.env.standalone?
			url_params[:subdomain] = 'boards'
		end
		url_for(url_params)
	end

	def board_edit_url(board)
		board_public_url(board) + "#edit"
	end

	def boards_engine
		@engine ||= BoardsHelper::BoardsEngine.new
	end

	class BoardsEngine
		include HTTParty
		base_uri ENV['BOARDS_URL']

		def initialize
			@auth = {:username => 'console', :password => ENV['CONSOLE_SECRET']}
		end

		def tap(widgetId, data)
			self.class.post("/tap/#{widgetId}", { :basic_auth => @auth, :headers => { "Content-Type" => "application/json" }, :body => data.to_json })
		end

		def runJob(widgetId)
			begin
				self.class.post("/schedule/widget/#{widgetId}", { :basic_auth => @auth })
			rescue
				Rails.logger.warn "Unable to run the job #{$!}"
			end
		end

		def deleteJob(widgetId)
			begin
				self.class.delete("/schedule/widget/#{widgetId}", { :basic_auth => @auth })
			rescue
				Rails.logger.warn "Unable to delete the job #{$!}"
			end
		end

		def deleteJobs(boardId)
			begin
				self.class.delete("/schedule/#{boardId}", { :basic_auth => @auth })
			rescue
				Rails.logger.warn "Unable to delete jobs #{$!}"
			end
		end
	end
end