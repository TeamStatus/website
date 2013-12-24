module UserNotifications
	extend ActiveSupport::Concern

	included do

		after_create do
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
	end
end