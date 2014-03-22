module BoardsHelper
	extend ActiveSupport::Concern

	def board_public_url(board)
		url_params = {controller: 'public_boards', action: 'show', publicId: board.public_id,
			host: request.host, port: request.port, protocol: request.protocol, subdomain: 'boards'}
		url_for(url_params)
	end

	def board_edit_url(board)
		board_public_url(board) + "#edit"
	end
end