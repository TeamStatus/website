class FixInvitedByIdInUsers < ActiveRecord::Migration
  def change
  	connection.execute(%q{
        alter table users
        alter column invited_by_id type uuid using null
    })
  end
end
