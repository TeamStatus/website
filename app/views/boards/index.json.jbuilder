json.array!(@boards) do |board|
  json.extract! board, :name
  json._id board._id.to_s
  json.view_url board_public_url(board)
  json.edit_url edit_board_url(board)
end
