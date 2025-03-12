class AddHierarchyToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :parent_id, :integer
    add_column :categories, :slug, :string
    add_column :categories, :description, :text

    add_index :categories, :parent_id
    add_index :categories, :slug, unique: true
    add_foreign_key :categories, :categories, column: :parent_id
  end
end
