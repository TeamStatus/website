class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs, id: :uuid do |t|
    	t.text :jobId, { null: false }
  		t.text :settings, { null: false, default: '' }
  		t.text :widgetSettings, { null: false, default: '' }
  		t.timestamps
    end
  end
end
