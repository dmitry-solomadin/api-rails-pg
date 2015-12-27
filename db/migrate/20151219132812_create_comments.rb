class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.column :text, :text
      t.column :author_id, :integer
      t.references(:parent, polymorphic: true, index: true)

      t.index :parent_id
      t.index :author_id
      t.timestamps null: false
    end
  end
end
