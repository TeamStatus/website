module Board::WidgetNotifications
	include BoardsHelper
	extend ActiveSupport::Concern

	included do
		after_save do |widget|
			boards_engine.schedule(widget._id)
		end
	end
end