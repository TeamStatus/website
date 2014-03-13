json.array!(@users) do |user|
	json.extract! user, :email, :callingName, :created_at
	json.boards user.boards do |board|
		json.widget board.jobs do |job|
			json.extract! job, :jobId
		end
	end
end