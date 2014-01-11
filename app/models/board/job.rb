class Board::Job
  include Mongoid::Document
  include Board::JobNotifications

  embedded_in :board

  field :jobId, type: String
  field :settings, type: Mongoid::EncryptedHash
  field :widgetSettings
end
