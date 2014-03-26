FactoryGirl.define do
	factory :user do
		email "jp@corp.com"
		password 'abc123'
		full_name "Jessica Parker"
		confirmed_at Proc.new { Time.now }
	end

	factory :board do
		name "Testing board"
	end
end