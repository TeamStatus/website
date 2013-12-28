class Board
    include Mongoid::Document
    include BoardNotifications

    store_in collection: "boards"

    belongs_to :user
    embeds_many :widgets, store_as: "settings", class_name: "Board::Widget"

    before_create :generate_publicId

    field :name, type: String
    field :publicId, type: String

    index({ :user_id => 1, :name => 1 }, { unique: true })
    index({ publicId: 1 }, { unique: true })

    def generate_publicId
      self.publicId = rand(36**10).to_s(36)
    end
end
