module Board::WidgetNotifications
	include BoardsHelper
	extend ActiveSupport::Concern

	included do
		after_save do |widget|
			boards_engine.runJob(widget._id)
		end

		after_destroy do |widget|
			boards_engine.deleteJob(widget._id)
		end
	end
end