class AllowNullsInJobs < ActiveRecord::Migration
  def change
  	change_column :jobs, :widgetSettings, :text, { null: true }
  	change_column :jobs, :settings, :text, { null: true }
  end
end
