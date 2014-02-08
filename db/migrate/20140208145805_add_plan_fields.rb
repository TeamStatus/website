class AddPlanFields < Mongoid::Migration
  def self.up
  	User.where({:plan_started_at => nil}).each do |user|
  		user.update_attributes(:plan_started_at => user.created_at, :plan_ending_at => 3.months.from_now, :plan_type => 'team')
  	end
  end

  def self.down
  end
end