json.array!(@widgets) do |widget|
  json.extract! widget, :widget
end
