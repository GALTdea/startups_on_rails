class Admin::FeaturableItemsController < Admin::BaseController
  before_action :set_featured_listing
  before_action :set_featurable_item, only: [ :create, :destroy ]

  def index
    @type = params[:type] || "Company"
    @query = params[:query]

    base_query = case @type
    when "Company"
                   Company.published
                         .joins(:categorizables)
                         .where(categorizables: { category_id: @featured_listing.category_id })
                         .where.not(id: FeaturedListing.where(featurable_type: "Company").select(:featurable_id))
    when "Solution"
                   Solution.published
                          .joins(:categorizables)
                          .where(categorizables: { category_id: @featured_listing.category_id })
                          .where.not(id: FeaturedListing.where(featurable_type: "Solution").select(:featurable_id))
    else
                   Company.published
                         .joins(:categorizables)
                         .where(categorizables: { category_id: @featured_listing.category_id })
                         .where.not(id: FeaturedListing.where(featurable_type: "Company").select(:featurable_id))
    end

    @featurable_items = if @query.present?
      base_query.class.search(@query)
    else
      base_query
    end

    # Debug information
    Rails.logger.debug "Featured Listing Category ID: #{@featured_listing.category_id}"
    Rails.logger.debug "Type: #{@type}"
    Rails.logger.debug "Query: #{@query}"
    Rails.logger.debug "Items Count: #{@featurable_items.count}"
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
