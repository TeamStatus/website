class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards, id: :uuid do |t|
    	t.text :name, {null: false, default: 'Team Board'}
    	t.timestamps
    end
  end
end
