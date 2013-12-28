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
			@auth = {:username => 'console', :password => 'console'}
		end

		def runJob(widgetId)
			self.class.post("/schedule/widget/#{widgetId}", { :basic_auth => @auth })
		end

		def deleteJob(widgetId)
			self.class.delete("/schedule/widget/#{widgetId}", { :basic_auth => @auth })
		end

		def deleteJobs(boardId)
			self.class.delete("/schedule/#{boardId}", { :basic_auth => @auth })
		end
	end
end