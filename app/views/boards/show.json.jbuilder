json.extract! @board, :name, :publicId
json._id @board._id.to_s
json.public_url board_public_url(@board)