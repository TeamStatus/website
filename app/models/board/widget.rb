class Board::Widget
  include Mongoid::Document
  include Board::WidgetNotifications

  embedded_in :board

  field :widget, type: String
  field :settings
  field :widgetSettings
end
