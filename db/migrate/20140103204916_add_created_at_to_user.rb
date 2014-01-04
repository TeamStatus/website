# check out http://pivotallabs.com/mongoid-migrations-using-the-mongo-driver/ for an example
class AddCreatedAtToUser < Mongoid::Migration
  def self.up
  	User.where({:created_at => nil}).each do |user|
  		user.update_attributes(:created_at => Time.now)
  	end
  end

  def self.down
  end
end