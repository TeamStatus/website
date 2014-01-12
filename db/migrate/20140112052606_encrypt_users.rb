class EncryptUsers < Mongoid::Migration
  def self.up
  	# force encrypted fields to encrypt fields
  	User.where({}).each do |user|
  		user.email = user.email
  		user.googleToken = user.googleToken
  		user.fullName = user.fullName
  		user.save
  	end
  end

  def self.down
  end
end