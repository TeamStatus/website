class Board
    include Mongoid::Document
    include BoardNotifications

    store_in collection: "boards"

    belongs_to :user
    embeds_many :jobs, store_as: "jobs", class_name: "Board::Job"

    before_create :reset_public_id

    field :name, type: String
    field :publicId, type: String

    index({ :user_id => 1, :name => 1 }, { unique: true })
    index({ :publicId => 1 }, { unique: true })

    def reset_public_id
      self.publicId = rand(36**10).to_s(36)
    end
end
