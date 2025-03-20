class PagesController < ApplicationController
  def index
    @featured_listings = FeaturedListing.includes(:category)
                                        .active.current.by_position

    @featured_companies = FeaturedListing.featured_by_category_type("industry")
                                         .includes(:category)

    @featured_technologies = FeaturedListing.featured_by_category_type("technology")
                                            .includes(:category)

    @featured_solutions = FeaturedListing.featured_by_category_type("solution")
                                         .includes(:category)

    load_featured_listing_items
    preload_polymorphic_associations
  end

  private

  def load_featured_listing_items
    all_listings = [ @featured_listings, @featured_companies, @featured_technologies, @featured_solutions ].flatten
    listing_ids = all_listings.map(&:id).uniq

    # Load all featured_listing_items in a single query
    items = FeaturedListingItem.where(featured_listing_id: listing_ids)

    # Group items by featured_listing_id for efficient assignment
    grouped_items = items.group_by(&:featured_listing_id)

    # Assign items to each listing
    all_listings.each do |listing|
      listing.instance_variable_set(:@featured_listing_items, grouped_items[listing.id] || [])
    end
  end

  def preload_polymorphic_associations
    # Load all featured listing items from all collections
    all_listings = [ @featured_listings, @featured_companies, @featured_technologies, @featured_solutions ].flatten
    items = all_listings.flat_map { |listing| listing.instance_variable_get(:@featured_listing_items) || [] }

    # Preload featurable associations
    preload_featurables(items)
  end

  def preload_featurables(items)
    items.group_by(&:featurable_type).each do |type, records|
      next if type.blank?

      model = type.constantize
      ids = records.map(&:featurable_id)
      featurables = model.where(id: ids).index_by(&:id)

      records.each do |item|
        item.featurable = featurables[item.featurable_id]
      end
    end
  end
end
