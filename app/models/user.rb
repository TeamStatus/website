class User < ActiveRecord::Base
	belongs_to :team, :inverse_of => :users
  	after_create :update_team

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	acts_as_token_authenticatable
	devise :invitable, :database_authenticatable, :registerable, :confirmable,
				 :recoverable, :rememberable, :trackable, :validatable, :omniauthable

	include UserNotifications
	include Gravtastic

	gravtastic :email,
	  :secure => true,
	  :filetype => :png,
	  :size => 15

	validates_presence_of :email

	has_many :authorizations

	has_many :boards, dependent: :destroy
	has_many :invitations, :class_name => self.to_s, :as => :invited_by

	def members
		@members ||= User.where("team_id = ? AND id != ?", self.team_id, self.id).order('email')
	end

	def self.new_with_session(params, session)
		if session["devise.user_attributes"]
			new(session["devise.user_attributes"], without_protection: true) do |user|
				user.attributes = params
				user.valid?
			end
		else
			super
		end
	end

	def self.from_omniauth(hash, current_user)
		authorization = Authorization.where(:provider => hash.provider, :uid => hash.uid.to_s,
			:token => hash.credentials.token, :secret => hash.credentials.secret).first_or_initialize

		if authorization.user.blank?
			logger.debug("Going to fetch details for #{hash}")
			authorization = authorization.fetch_details_and_create_user(hash, current_user)
		end

		authorization.user
	end

	after_invitation_accepted :email_invited_by

	def email_invited_by
   # ...
	end

	def admin?
		type == 'Admin'
	end

	def update_team
	  	# get or create a subdomain on creating a new user
	  	unless team
	  		self.team ||= Team.create!
	  		self.save
	  	end
	end

end
