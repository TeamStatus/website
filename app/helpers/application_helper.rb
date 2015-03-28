module ApplicationHelper

	def contact_phone
		'+48 609 657 575'
	end

	def contact_phone_url
		'tel:+48-609-657-575'
	end

	def contact_email
		'pawel@teamstatus.tv'
	end

	def body_class
    [controller_name, action_name].join('-')
  end

end
