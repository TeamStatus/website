class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
    	t.text :username
      t.text :provider
      t.text :uid
      t.text :token
      t.text :secret

			t.uuid :user_id

      t.timestamps
    end
  end
end
