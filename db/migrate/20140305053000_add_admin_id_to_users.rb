class AddAdminIdToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :admin_id, :uuid
  	add_index :users, :admin_id
  end

  def self.down
  	raise ActiveRecord::IrreversibleMigration
  end
end
