module SendsNotifications
	extend ActiveSupport::Concern

	included do
		after_create do |document|
			send_notification("created", document)
		end

		after_save do |document|
			send_notification("saved", document)
		end

		after_destroy do |document|
			send_notification("destroyed")
		end
	end

	def send_notification(verb, object)
		logger.info("Operation on #{verb} #{object}")
	end
end