json.extract! @board, :name, :public_id
json._id @board.id.to_s
json.public_url board_public_url(@board)