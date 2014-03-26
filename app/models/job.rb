class Job < ActiveRecord::Base
	include ActiveModel::Dirty

  belongs_to :board

  serialize :widgetSettings
  serialize :settings
  serialize :last_data

	after_save :kick_off_job

	def kick_off_job
		if self.settings_changed? or self.widgetSettings_changed?
			RunJobWorker.perform_async(self.id)
		end
  end
end
