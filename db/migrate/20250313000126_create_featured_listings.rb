class CreateFeaturedListings < ActiveRecord::Migration[8.0]
  def change
    create_table :featured_listings do |t|
      t.string :title, null: false
      t.text :description
      t.references :category, null: false, foreign_key: true
      t.integer :position, default: 0
      t.boolean :active, default: true
      t.datetime :featured_until

      t.timestamps
    end

    add_index :featured_listings, :position
    add_index :featured_listings, :active
  end
end
