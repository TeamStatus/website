json.array!(@board.jobs) do |job|
	json.extract! job, :jobId, :widgetSettings
end