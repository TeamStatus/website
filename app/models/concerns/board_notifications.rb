module BoardNotifications
	include BoardsHelper
	extend ActiveSupport::Concern

	included do
		after_destroy do |board|
			boards_engine.schedule(board._id)
		end
	end
end