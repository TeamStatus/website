class Widget::Setting
  include Mongoid::Document

  embedded_in :board

  field :widget, type: String
end
