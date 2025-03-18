class Admin::FeaturableItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_featured_listing
  before_action :set_featurable_item, only: [ :create, :destroy ]

  def index
    @type = params[:type] || "Company"
    @query = params[:query]

    @featurable_items = case @type
    when "Company"
                         Company.not_featured.where(category: @featured_listing.category)
    when "Solution"
                         Solution.not_featured.where(category: @featured_listing.category)
    else
                         Company.not_featured.where(category: @featured_listing.category)
    end

    @featurable_items = @featurable_items.search(@query) if @query.present?
  end

  def create
    @featured_listing.update(featurable: @featurable_item)

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "featured_listing_#{@featured_listing.id}",
          partial: "admin/featured_listings/featured_listing",
          locals: { featured_listing: @featured_listing }
        )
      }
      format.html { redirect_to admin_featured_listings_path, notice: "Item was successfully featured." }
    end
  end

  def destroy
    @featured_listing.update(featurable: nil)

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "featured_listing_#{@featured_listing.id}",
          partial: "admin/featured_listings/featured_listing",
          locals: { featured_listing: @featured_listing }
        )
      }
      format.html { redirect_to admin_featured_listings_path, notice: "Item was successfully unfeatured." }
    end
  end

  private

  def set_featured_listing
    @featured_listing = FeaturedListing.find(params[:featured_listing_id])
  end

  def set_featurable_item
    @featurable_item = params[:type].constantize.find(params[:id])
  end
end
