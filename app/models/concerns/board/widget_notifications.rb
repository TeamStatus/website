module Board::WidgetNotifications
	include BoardsHelper
	extend ActiveSupport::Concern

	included do
		after_save do |widget|
			boards_engine.schedule(widget.board_id)
		end

		after_destroy do |widget|
			boards_engine.schedule(widget.board_id)
		end
	end
end