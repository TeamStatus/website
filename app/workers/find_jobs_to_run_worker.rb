class FindJobsToRunWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

	recurrence { minutely }

  def perform(last_occurrence, current_occurrence)
  	DueJobsQuery.new.find_each do |job|
  		RunJobWorker.perform_async(job.id)
  	end
  end
end