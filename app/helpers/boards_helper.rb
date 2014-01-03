module BoardsHelper
	extend ActiveSupport::Concern

	def board_public_url(board)
	  url = URI(ENV['BOARDS_URL'])
	  url.path = "/" + board.publicId
	  url.to_s
	end

	def board_edit_url(board)
	  url = URI(ENV['BOARDS_URL'])
	  url.path = "/" + board._id + "/edit"
	  url.to_s
	end

	def boards_engine
		@engine ||= BoardsHelper::BoardsEngine.new()
	end

	class BoardsEngine
		include HTTParty
		base_uri ENV['BOARDS_URL']

		def initialize
			@auth = {:username => 'console', :password => ENV['CONSOLE_SECRET']}
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