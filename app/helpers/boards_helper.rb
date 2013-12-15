module BoardsHelper
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
end