class User
  include Mongoid::Document
  include UserNotifications

  store_in collection: "users"

  has_many :boards

  field :email, type: Mongoid::EncryptedString
  field :fullName, type: Mongoid::EncryptedString
  field :callingName, type: String
  field :picture, type: String
  field :googleToken, type: Mongoid::EncryptedString
  field :googleTokenExpires, type: Time
  field :male, type: Boolean
  field :created_at, type: Time, default: -> { Time.now }

  field :plan_started_at, type: Time, default: -> { Time.now }
  field :plan_ending_at, type: Time, default: -> { 30.days.from_now }
  field :plan_type, type: String, default: 'trial'

  index({ email: 1 }, { unique: true })
end
