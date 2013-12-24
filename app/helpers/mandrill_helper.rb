module MandrillHelper
	def mandrill
    if (ENV['MANDRILL_KEY'])
      @mandrill ||= ::Mandrill::API.new ENV['MANDRILL_KEY']
    end
	end
end