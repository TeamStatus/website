# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

task "bower_install" do
  `(cd /tmp && curl -O https://heroku-buildpack-nodejs.s3.amazonaws.com/nodejs-0.10.21.tgz)`
  `(mkdir -p bin/nodejs && cd bin/nodejs && tar xzf /tmp/nodejs-0.10.21.tgz)`
  `bin/nodejs/bin/node bin/nodejs/bin/npm install`
end

task "assets:precompile" => "bower_install"

ConsoleRails::Application.load_tasks
