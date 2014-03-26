class AddTypeToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :type, :text, {null: false, default: 'User'}
  	rename_column :users, :admin_id, :team_id

  	execute <<-SQL
  		UPDATE users SET team_id = id, type='Admin' WHERE team_id IS NULL
  	SQL
  end
end
