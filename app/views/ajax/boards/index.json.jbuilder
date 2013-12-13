json.array!(@boards) do |board|
  json.extract! board, :name
end
