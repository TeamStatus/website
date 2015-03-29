class Authorization < ActiveRecord::Base
	belongs_to :user

	def fetch_details_and_create_user(hash, current_user)
		user = self.send("fetch_details_from_#{self.provider.downcase}", hash, current_user)
		
		user.password ||= Devise.friendly_token[0,10]
		user.calling_name ||= ''
		user.full_name ||= ''
		user.picture ||= ''

		self.provider == 'twitter' ? user.save(:validate => false) : user.save!

		self.user_id = user.id
		self.save!
		self
	end

	def fetch_details_from_facebook(hash, current_user)
		graph = Koala::Facebook::API.new(self.token)
		facebook_data = graph.get_object("me")
		
		self.username = facebook_data['username']

		user = current_user.nil? ? User.where('email = ?', hash["info"]["email"]).first : current_user
		if user.blank?
			user = User.new
			
			user.email = hash.info.email
			user.full_name = hash.info.name if hash.info.respond_to? 'name'
			user.full_name = hash.info.full_name if hash.info.respond_to? 'full_name' and user.full_name.nil?
			user.calling_name = hash.info.given_name if hash.info.respond_to? 'given_name'
			user.male = hash.info.gender == "male" if hash.info.respond_to? 'male'
		end
		user
	end

	def fetch_details_from_twitter(hash, current_user)
		user = current_user.nil? ? User.where('email = ?', hash["info"]["email"]).first : current_user
		if user.blank?
			user = User.new
			user.password = Devise.friendly_token[0,10]
			user.email = hash.info.email
			user.full_name = hash.info.name if hash.info.respond_to? 'name'
			user.full_name = hash.info.full_name if hash.info.respond_to? 'full_name' and user.full_name.nil?
			user.calling_name = hash.info.given_name if hash.info.respond_to? 'given_name'
			user.male = hash.info.gender == "male" if hash.info.respond_to? 'male'
		end
		user
	end

	def fetch_details_from_github(hash, current_user)
		user = current_user.nil? ? User.where('email = ?', hash["info"]["email"]).first : current_user
		if user.blank?
			user = User.new
			user.password = Devise.friendly_token[0,10]
			user.email = hash.info.email
			user.full_name = hash.info.name if hash.info.respond_to? 'name'
			user.full_name = hash.info.full_name if hash.info.respond_to? 'full_name' and user.full_name.nil?
			user.calling_name = hash.info.given_name if hash.info.respond_to? 'given_name'
			user.male = hash.info.gender == "male" if hash.info.respond_to? 'male'
		end
		user
	end

	def fetch_details_from_linkedin(hash, current_user)
		user = current_user.nil? ? User.where('email = ?', hash["info"]["email"]).first : current_user
		if user.blank?
			user = User.new
			user.password = Devise.friendly_token[0,10]
			user.email = hash.info.email
			user.full_name = hash.info.name if hash.info.respond_to? 'name'
			user.full_name = hash.info.full_name if hash.info.respond_to? 'full_name' and user.full_name.nil?
			user.calling_name = hash.info.given_name if hash.info.respond_to? 'given_name'
			user.male = hash.info.gender == "male" if hash.info.respond_to? 'male'
		end
		user
	end

	def fetch_details_from_google_oauth2(hash, current_user)
		user = current_user.nil? ? User.where('email = ?', hash["info"]["email"]).first : current_user
		if user.blank?
			user = User.new
			user.password = Devise.friendly_token[0,10]
			user.email = hash.info.email
			user.full_name = hash.info.name if hash.info.respond_to? 'name'
			user.full_name = hash.info.full_name if hash.info.respond_to? 'full_name' and user.full_name.nil?
			user.calling_name = hash.info.given_name if hash.info.respond_to? 'given_name'
			user.male = hash.info.gender == "male" if hash.info.respond_to? 'male'
		end
		user
	end

	def fetch_details_from_slack(hash, current_user)
		slack = Slack::RPC::Client.new(self.token)
		response = slack.users.info(user: self.uid)

		self.username = response.body['user']['name']

		user = current_user.nil? ? User.where('email = ?', response.body['user']['profile']['email']).first : current_user
		if user.blank?
			logger.debug("Going to create a new user")

			user = User.new
			user.password = Devise.friendly_token[0,10]
			user.email = response.body['user']['profile']['email']
			user.full_name = response.body['user']['profile']['real_name']
			user.calling_name = response.body['user']['profile']['first_name']
		end
		user
	end
end
