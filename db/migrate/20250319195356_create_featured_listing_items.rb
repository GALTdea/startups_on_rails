class CreateFeaturedListingItems < ActiveRecord::Migration[8.0]
  def change
    create_table :featured_listing_items do |t|
      t.references :featured_listing, null: false, foreign_key: true
      t.references :featurable, polymorphic: true, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :featured_listing_items, [ :featured_listing_id, :featurable_type, :featurable_id ],
              unique: true,
              name: 'index_featured_listing_items_on_featured_listing_and_featurable'
    add_index :featured_listing_items, [ :featured_listing_id, :position ]
  end
end
