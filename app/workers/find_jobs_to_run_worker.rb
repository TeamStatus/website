class FindJobsToRunWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

	recurrence { minutely }

  def perform(last_occurrence, current_occurrence)
  	DueJobsQuery.new.find_each do |job|
  		logger.info "Queuing reminder for #{user.id} #{user.email}"
  		user.send_todays_reminder
  	end
  end
end