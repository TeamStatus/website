class DataController < WebsocketRails::BaseController
  def client_connected
    logger.info "client #{client_id} connected"
  end

  def client_disconnected
    logger.info "client #{client_id} disconnected"
  end

  def resend
    logger.info "Resend received for #{message}"
    job = Job.find(message)
    if job.last_data
      send_message job.id, job.last_data
    else
      RunJobWorker.perform_async(job.id)
    end
  end
end