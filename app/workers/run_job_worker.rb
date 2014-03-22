class RunJobWorker
	include Sidekiq::Worker

  def perform(job_id)
  	job = Job.find(job_id)

  	IO.popen("node #{Rails.root}/lib/pullers/standalone.js #{job.jobId}", "w+") do |sub|
  		sub.write job.settings.to_json
  		sub.close_write
  		output = sub.read
  		sub.close

  		if $?.to_i == 0
  			job.last_data = JSON.parse output
  		end
  	end

  	job.last_run_at = Time.now()
  	job.next_run_at = Time.now() + 1.minute
  	job.save
  end
end