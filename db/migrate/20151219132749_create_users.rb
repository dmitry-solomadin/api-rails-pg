class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :email, :string, null: false
      t.column :password, :string, null: false

      t.timestamps null: false
    end
  end
end
