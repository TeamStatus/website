class RunJobWorker
	include Sidekiq::Worker

  def perform(job_id)
  	job = Job.find_by_id(job_id)
    unless job.nil?
    	IO.popen("#{Rails.root}/lib/pullers/standalone #{job.jobId}", "w+") do |sub|
    		sub.write job.settings.to_json
    		sub.close_write
    		output = sub.read
    		sub.close

    		if $?.to_i == 0
    			job.last_data = JSON.parse output

          WebsocketRails[job.board.id].trigger job.id, job.last_data
        else
          logger.warn "There was an error running job #{job.id} #{output}"
    		end
    	end
    end

  	job.last_run_at = Time.now()
  	job.next_run_at = Time.now() + 1.minute
  	job.save
  end
end