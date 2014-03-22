class RunJobWorker
	include Sidekiq::Worker

  def perform(job_id)
  	job = Job.find(job_id)
  	job.last_run_at = Time.now()
  	job.next_run_at = Time.now() + 1.minute
  	job.save
  end
end