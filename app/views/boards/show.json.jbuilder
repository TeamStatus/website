json.extract! @board, :name, :public_id
json._id @board.id.to_s
json.public_url public_board_url(@board)