module BoardsHelper
	extend ActiveSupport::Concern

	def boards_base_url
		if Rails.env.standalone?
			uri = URI("#{request.protocol}#{request.host_with_port}")
			uri.path = '/boards'
			uri
		else
			URI(ENV['BOARDS_URL'])
		end
	end

	def board_public_url(board)
	  url = boards_base_url
	  url.path = url.path + '/' + board.publicId
	  url.to_s
	end

	def board_edit_url(board)
	  url = boards_base_url
	  url.path = url.path + "/" + board._id + "/edit"
	  url.to_s
	end

	def boards_engine
		@engine ||= BoardsHelper::BoardsEngine.new(boards_base_url)
	end

	class BoardsEngine
		include HTTParty

		def initialize(base_url)
			@auth = {:username => 'console', :password => ENV['CONSOLE_SECRET']}
			base_uri base_url
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