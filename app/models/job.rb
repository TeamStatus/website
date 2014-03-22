class Job < ActiveRecord::Base

    belongs_to :board

    serialize :widgetSettings
    serialize :settings
    serialize :last_data

end
