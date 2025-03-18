class AddFeaturableToFeaturedListings < ActiveRecord::Migration[8.0]
  def change
    # First add the columns as nullable
    add_reference :featured_listings, :featurable, polymorphic: true, null: true

    # If you have existing records that need to be migrated, you can add them here
    # For example:
    # FeaturedListing.find_each do |listing|
    #   listing.update(featurable_type: 'Company', featurable_id: listing.company_id) if listing.company_id.present?
    # end

    # Finally, make the columns non-nullable
    change_column_null :featured_listings, :featurable_type, false
    change_column_null :featured_listings, :featurable_id, false
  end
end
