module UserNotifications
	include MandrillHelper
	include ApplicationHelper

	extend ActiveSupport::Concern

	included do

		after_create do |user|
			if Rails.env.production?
				if mandrill
				  begin
				    message = {
				      :subject=> "New User for TeamStatus.TV",
				      :text=>"You have a new user #{user.email.nil? ? user.unconfirmed_email : user.email}",
				      :from_name=> "TeamStatus.TV",
				      :from_email=> "root@teamstatus.tv",
				      :to=>[
				        {:email => "pawel@teamstatus.tv", :name => "Pawel Niewiadomski"}
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
end