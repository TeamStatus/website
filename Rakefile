# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

namespace :assets do
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
end

task "assets:precompile" => "assets:bower_install"

namespace :db do
  namespace :production do
    # more ideas at http://artsy.github.io/blog/2013/01/31/create-mongodb-command-lines-with-mongo/
    task :mongoid do
      ENV = Figaro.env 'production'
      Mongoid.load! File.join(Rails.root, "config/mongoid.yml"), :production
    end

    desc "Run MongoDB Shell to production database"
    task :shell => :mongoid do
      system Mongoid::Shell::Commands::Mongo.new.to_s
    end

    desc "Run MongoDB dump for production database"
    task :dump => :mongoid do
      out = File.join(Dir.tmpdir, 'db_backup')
      system Mongoid::Shell::Commands::Mongodump.new(out: out).to_s # mongodump --db another_database --out /tmp/db_backup
    end
  end
end

ConsoleRails::Application.load_tasks
