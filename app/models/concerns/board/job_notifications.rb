module Board::JobNotifications
	include BoardsHelper
	extend ActiveSupport::Concern

	included do
		after_save do |job|
			boards_engine.runJob(job._id)
		end

		after_destroy do |job|
			boards_engine.deleteJob(job._id)
		end
	end
end