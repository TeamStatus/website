class AddJobTrackingToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :last_run_at, :timestamp
  	add_column :jobs, :next_run_at, :timestamp
  	add_column :jobs, :last_data, :text

  	add_index :jobs, :next_run_at
  end
end
