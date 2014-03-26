class AddBoardIdToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :board_id, :uuid, { null: false }
  end
end
