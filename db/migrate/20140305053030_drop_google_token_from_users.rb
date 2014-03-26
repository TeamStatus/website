class DropGoogleTokenFromUsers < ActiveRecord::Migration
  def self.up
  	remove_column :users, :google_token
  	remove_column :users, :google_token_expires
  end

  def self.down
  	raise ActiveRecord::IrreversibleMigration
  end
end
