class AddPublicIdToBoards < ActiveRecord::Migration
  def change
  	add_column :boards, :public_id, :text, { null: false }
  end
end
