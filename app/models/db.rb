require "mongoid"
require "uri"

class Server
  include Mongoid::Document
  store_in collection: "servers"

  belongs_to :user

  field :address, type: String
  field :username, type: String
  field :password, type: String
  field :product, type: String, default: "jira"

  index({ :user_id => 1, :address => 1 }, { unique: true })
end

class Widgetsetting
  include Mongoid::Document

  embedded_in :board

  field :widget, type: String
end
