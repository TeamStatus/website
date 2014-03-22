class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams, id: :uuid do |t|
    	t.text :name, {null: false, default: 'Team'}
    	t.timestamps
    end

    execute <<-SQL
    	INSERT INTO teams (id) (SELECT id FROM users WHERE type = 'Admin')
    SQL
  end
end
