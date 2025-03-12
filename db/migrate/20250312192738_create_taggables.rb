class CreateTaggables < ActiveRecord::Migration[8.0]
  def change
    create_table :taggables do |t|
      t.integer :taggable_id, null: false
      t.string :taggable_type, null: false
      t.integer :tag_id, null: false

      t.timestamps
    end

    add_index :taggables, [ :taggable_id, :taggable_type ]
    add_index :taggables, :tag_id
    add_index :taggables, [ :taggable_id, :taggable_type, :tag_id ], unique: true, name: 'index_taggables_uniqueness'

    add_foreign_key :taggables, :tags
  end
end
