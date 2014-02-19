FactoryGirl.define do
	factory :user do
		email "admin@localhost"
		fullName "Administrator"
	end

	factory :board do
		name "Testing board"
	end
end