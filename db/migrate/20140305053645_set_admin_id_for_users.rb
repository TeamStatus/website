class SetAdminIdForUsers < ActiveRecord::Migration
  def change
  	execute <<-SQL
  		UPDATE users SET admin_id = CASE WHEN invited_by_id IS NULL THEN NULL WHEN invited_by_id IS NOT NULL THEN invited_by_id END
  	SQL
  end
end
