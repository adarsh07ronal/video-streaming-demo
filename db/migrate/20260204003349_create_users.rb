class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :google_uid

      t.timestamps
    end
    add_index :users, :google_uid
  end
end
