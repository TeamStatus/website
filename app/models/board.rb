class Board < ActiveRecord::Base
    include BoardNotifications

    belongs_to :user
    has_many :jobs

    before_create :reset_public_id

    def reset_public_id
      self.public_id = rand(36**10).to_s(36)
    end
end
