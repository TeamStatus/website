worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)

# combine Ruby 2.0.0dev or REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

check_client_connection false

preload_app true

# Restart any workers that haven't responded in 30 seconds
timeout 30

if File.directory? ('/var/www/teamstatus.tv')
  working_directory '/var/www/teamstatus.tv/current'

  # Listen on a Unix data socket
  pid '/var/www/teamstatus.tv/shared/tmp/pids/unicorn.pid'
  listen "/var/www/teamstatus.tv/tmp/sockets/teamstatus.tv.sock", :backlog => 2048
  stderr_path "/var/www/teamstatus.tv/current/log/unicorn.log"
  stdout_path "/var/www/teamstatus.tv/current/log/unicorn.log"

  before_exec do |server|
    ENV["BUNDLE_GEMFILE"] = "/var/www/teamstatus.tv/current/Gemfile"
  end
end

before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = '/var/www/teamstatus.tv/shared/tmp/pids/unicorn.pid.oldbin'

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  # other settings
  if defined?(ActiveRecord::Base)
    config = ActiveRecord::Base.configurations[Rails.env]
    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
    config['pool']            =   ENV['DB_POOL'] || 2
    ActiveRecord::Base.establish_connection(config)
  end
end
