class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.column :body, :text, null: false
      t.column :header, :string, null: false
      t.column :author_id, :integer, null: false
      t.index :author_id

      t.timestamps null: false
    end
  end
end
