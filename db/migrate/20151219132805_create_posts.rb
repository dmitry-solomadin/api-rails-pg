class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.column :body, :text
      t.column :header, :string
      t.column :author_id, :integer
      t.index :author_id

      t.timestamps null: false
    end
  end
end
