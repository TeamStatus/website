module MixpanelHelper
	def mixpanel_id
		return ENV['MIXPANEL_ID']
	end
end