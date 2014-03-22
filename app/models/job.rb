class Job < ActiveRecord::Base

    belongs_to :board

    serialize :widgetSettings
    serialize :settings

end
