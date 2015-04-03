class UpdateAuthenticationToken < ActiveRecord::Migration
  def change
  	User.all.each do |user|
  		user.authentication_token = Devise.friendly_token
  		user.save
  	end
  end
end
