class AddIndexToPublicId < ActiveRecord::Migration
  def change
  	add_index :boards, :public_id, unique: true
  end
end
