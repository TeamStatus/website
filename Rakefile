# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

def which(cmd)
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each { |ext|
      exe = File.join(path, "#{cmd}#{ext}")
      return exe if File.executable? exe
    }
  end
  return nil
end

task "bower_install" do
	unless which 'bower'
  	`(cd /tmp && curl -O https://heroku-buildpack-nodejs.s3.amazonaws.com/nodejs-0.10.20.tgz)`
  	`(rm -rf bin/nodejs && mkdir -p bin/nodejs && cd bin/nodejs && tar xzf /tmp/nodejs-0.10.20.tgz)`
  	`bin/nodejs/bin/node bin/nodejs/bin/npm install`
	end
end

task "assets:precompile" => "bower_install"

ConsoleRails::Application.load_tasks
