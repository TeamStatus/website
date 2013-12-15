class LoginController < ActionController::Base
	before_action :set_google, only: [:google, :google_callback]

	def index
	end

	def google
	  session[:user_id] = nil
	  session[:state] = Digest::MD5.hexdigest(rand().to_s)

	  logger.info("Using #{ENV['MONGOHQ_URL']}")

	  redirect_to @google.auth_code.authorize_url(:redirect_uri => url_for(:action => 'google_callback'),
	    :scope => 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email',
	    :access_type => "online", :state => session[:state]), :status => 303
	end

	def google_callback
	  halt 403 unless session[:state] == params[:state]

	  access_token = @google.auth_code.get_token(params[:code], :redirect_uri => url_for(:action => 'google_callback'))
	  profile = access_token.get('https://www.googleapis.com/oauth2/v1/userinfo?alt=json').parsed.with_indifferent_access
	  logger.info("Profile is #{profile.to_json}")

	  user = ::User.where(email: profile[:email]).first
	  if not user
	    logger.info("User was not found " + profile[:email])
	    user = ::User.create!(email: profile[:email], fullName: profile[:name], callingName: profile[:given_name],
	      picture: profile[:picture], male: profile[:gender] == "male")

	    Intercom::User.create(:email => profile[:email], :created_at => user.created_at, :name => profile[:name], :user_id => user._id)
	    Intercom::Tag.create(:name => 'Beta', :emails => [ profile[:email] ], :tag_or_untag => 'tag')

	    if mandrill
	      begin
	        message = {
	          :subject=> "New User for TeamStatus.TV",
	          :text=>"You have a new user #{user.email}",
	          :from_name=> "TeamStatus.TV",
	          :from_email=> "root@teamstatus.tv",
	          :to=>[
	            {:email => "pawelniewiadomski@me.com", :name => "Pawel Niewiadomski"}
	          ]
	        }
	        mandrill.messages.send message
	      rescue Mandrill::Error => e
	        logger.error("A mandrill error occurred: #{e.class} - #{e.message}")
	      end
	    end
	  end

	  session[:user_id] = user._id.to_s
	  redirect_to :controller => 'boards'
	end

	private

		def set_google
		  @google ||= ::OAuth2::Client.new(ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {
		    :site => 'https://accounts.google.com',
		    :authorize_url => "/o/oauth2/auth",
		    :token_url => "/o/oauth2/token"
		  })
		end

		def mandrill
	    if (ENV['MANDRILL_KEY'])
	      @mandrill ||= ::Mandrill::API.new ENV['MANDRILL_KEY']
	    end
		end
end