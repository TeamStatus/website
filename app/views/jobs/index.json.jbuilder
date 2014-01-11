json.array!(@jobs) do |job|
  json.extract! job, :jobId, :widgetSettings, :settings
  json._id job._id.to_s
end
