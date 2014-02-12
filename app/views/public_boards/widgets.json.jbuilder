json.array!(@board.jobs) do |job|
	json.extract! job, :jobId, :widgetSettings
	json._id job._id.to_s
end