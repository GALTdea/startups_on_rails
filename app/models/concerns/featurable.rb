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
