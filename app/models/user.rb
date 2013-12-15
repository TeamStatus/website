class User
  include Mongoid::Document
  store_in collection: "users", session: 'default'

  has_many :boards
  has_many :servers

  field :email, type: String
  field :fullName, type: String
  field :callingName, type: String
  field :picture, type: String
  field :googleToken, type: String
  field :googleTokenExpires, type: Time
  field :male, type: Boolean
  field :created_at, type: Time, default: -> { Time.now }

  index({ email: 1 }, { unique: true })
end
