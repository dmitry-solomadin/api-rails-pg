class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.column :text, :text, null: false
      t.column :post_id, :string
      t.references(:parent, polymorphic: true, index: true)

      t.index :parent_id
      t.timestamps null: false
    end
  end
end
