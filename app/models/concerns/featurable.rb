# Featurable concern providing shared behavior for models that can be featured.
#
# Key features:
# - Adds featured? method to check if an item is actively featured
# - Sets up associations with featured listings
# - Adds scopes for filtering featured and non-featured items
#
# This concern is included in models like Company and Solution to make
# them "featurable" - able to be highlighted in featured listings.
module Featurable
  extend ActiveSupport::Concern

  included do
    has_one :featured_listing, as: :featurable, dependent: :destroy

    scope :featured, -> { joins(:featured_listing).merge(FeaturedListing.featured) }
    scope :not_featured, -> {
      left_joins(:featured_listing)
        .where(featured_listings: { id: nil })
    }
  end

  def featured?
    featured_listing.present? && featured_listing.active? && !featured_listing.expired?
  end
end
