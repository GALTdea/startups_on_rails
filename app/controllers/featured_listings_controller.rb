class FeaturedListingsController < ApplicationController
  def index
    @featured_listings = FeaturedListing.includes(:category, :featured_listing_items)
                                      .active
                                      .current
                                      .by_position
  end

  def show
    @featured_listing = FeaturedListing.includes(:category, featured_listing_items: :featurable)
                                     .active
                                     .current
                                     .find(params[:id])
  end
end
