class CreateCategorizables < ActiveRecord::Migration[8.0]
  def change
    create_table :categorizables do |t|
      t.integer :categorizable_id, null: false
      t.string :categorizable_type, null: false
      t.integer :category_id, null: false

      t.timestamps
    end

    add_index :categorizables, [ :categorizable_id, :categorizable_type ]
    add_index :categorizables, :category_id
    add_index :categorizables, [ :categorizable_id, :categorizable_type, :category_id ], unique: true, name: 'index_categorizables_uniqueness'

    add_foreign_key :categorizables, :categories
  end
end
