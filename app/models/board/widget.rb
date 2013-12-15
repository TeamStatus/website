class Board::Widget
  include Mongoid::Document

  embedded_in :board

  field :widget, type: String
  field :settings
  field :widgetSettings
end
