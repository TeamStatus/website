class Board
    include Mongoid::Document
    store_in collection: "boards"

    belongs_to :user
    embeds_many :widgetsettings, store_as: "settings"

    before_create :generate_publicId

    field :name, type: String
    field :publicId, type: String

    index({ :user_id => 1, :name => 1 }, { unique: true })
    index({ publicId: 1 }, { unique: true })

    def generate_publicId
      self.publicId = rand(36**10).to_s(36)
    end

    def public_url
      url = URI(ENV['BOARDS_URL'])
      url.path = "/" + self.publicId
      url.to_s
    end

    def edit_url
      url = URI(ENV['BOARDS_URL'])
      url.path = "/" + self._id + "/edit"
      url.to_s
    end
end
