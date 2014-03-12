json.array!(@users) do |user|
	json.extract! user, :email, :callingName, :created_at
end