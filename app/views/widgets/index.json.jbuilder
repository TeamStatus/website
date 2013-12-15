json.array!(@widgets) do |widget|
  json.extract! widget, :widget, :widgetSettings, :settings
  json._id widget._id.to_s
end
