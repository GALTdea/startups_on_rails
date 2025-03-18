class AddFeaturableToFeaturedListings < ActiveRecord::Migration[8.0]
  def change
    add_reference :featured_listings, :featurable, polymorphic: true, null: false
  end
end
