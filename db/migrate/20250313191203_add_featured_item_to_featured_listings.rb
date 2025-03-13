class AddFeaturedItemToFeaturedListings < ActiveRecord::Migration[8.0]
  def change
    add_column :featured_listings, :featured_item_type, :string
    add_column :featured_listings, :featured_item_id, :integer
    add_index :featured_listings, [ :featured_item_type, :featured_item_id ], name: 'index_featured_listings_on_featured_item'
  end
end
