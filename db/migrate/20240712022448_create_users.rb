class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: "grepp@grepp.com"
      t.string :name, null: false, default: "김그랩"
      t.string :role, null: false, default: "user"
      t.string :password, null: false, default: "password"
      t.timestamps
    end
  end
end
