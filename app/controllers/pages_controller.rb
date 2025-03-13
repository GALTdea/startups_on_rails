class PagesController < ApplicationController
  def index
    @featured_companies = FeaturedListing.featured_by_category_type("industry")
    @featured_technologies = FeaturedListing.featured_by_category_type("technology")
    @featured_solutions = FeaturedListing.featured_by_category_type("solution")
  end
end
