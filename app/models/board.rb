class Board
    include Mongoid::Document
    include BoardNotifications

    store_in collection: "boards"

    belongs_to :user
    embeds_many :jobs, store_as: "jobs", class_name: "Board::Job"

    before_create :generate_publicId

    field :name, type: String
    field :publicId, type: String

    index({ :user_id => 1, :name => 1 }, { unique: true })
    index({ :publicId => 1 }, { unique: true })

    def generate_publicId
      self.publicId = rand(36**10).to_s(36)
    end
end
