module MandrillHelper
	def mandrill
    if (ENV['MANDRILL_APIKEY'])
      @mandrill ||= ::Mandrill::API.new ENV['MANDRILL_APIKEY']
    end
	end
end