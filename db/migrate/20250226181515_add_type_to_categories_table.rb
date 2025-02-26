class AddTypeToCategoriesTable < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :category_type, :string
    add_index :categories, :category_type
  end
end
