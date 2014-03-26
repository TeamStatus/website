module PublicBoardsHelper

	def public_board_path(board)
    "/b/#{board.public_id}"
	end

	def public_board_url(board)
		"#{request.protocol}#{request.host_with_port}" + public_board_path(board)
	end

end