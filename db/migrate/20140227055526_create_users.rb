class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.text :email, {null: false}
      t.text :full_name, {null: false, default: ''}
      t.text :calling_name, {null: false, default: ''}
      t.text :picture, {null: false, default: ''}
      t.text :google_token, {null: false, default: ''}
      t.timestamp :google_token_expires
      t.boolean :male

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
