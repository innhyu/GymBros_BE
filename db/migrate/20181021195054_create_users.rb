class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :facebook_id
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :password_digest
      t.integer :age
      t.string :role

      t.timestamps
    end
  end
end
