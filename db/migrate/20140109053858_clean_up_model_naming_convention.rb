class CleanUpModelNamingConvention < Mongoid::Migration
  def self.up
  	Board.where({'settings' => {'$ne' => nil}}).update_all('$rename' => {'settings' => 'jobs'})
  	Board.where({'jobs.widget' => {'$ne' => nil}}).each do |board|
      board.jobs.where({:jobId => nil}).each do |job|
        job.set(:jobId => job.read_attribute(:widget))
        job.unset(:widget)
      end
    end
  end

  def self.down
    Board.where({'jobs' => {'$ne' => nil}}).update_all('$rename' => {'jobs' => 'settings'})
    Board.where({'jobs.jobId' => {'$ne' => nil}}).each do |board|
      board.jobs.where({:widget => nil}).each do |job|
        job.set(:widget => job.read_attribute(:jobId))
        job.unset(:jobId)
      end
    end
  end
end