class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email_address, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.date :birth_date, null: false
      t.integer :age, null: false
      t.boolean :admin, default: false
      t.timestamps
    end
  end
end
