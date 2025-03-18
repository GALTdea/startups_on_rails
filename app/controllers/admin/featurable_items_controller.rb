class Admin::FeaturableItemsController < Admin::BaseController
  before_action :set_featured_listing
  before_action :set_featurable_item, only: [ :create, :destroy ]

  def index
    @featured_listing = FeaturedListing.find(params[:featured_listing_id])
    @type = params[:type] || "Company"
    @search = params[:search]

    # Start with the base class
    klass = @type.constantize

    # Log initial parameters
    Rails.logger.debug "Search Parameters:"
    Rails.logger.debug "Type: #{@type}"
    Rails.logger.debug "Search Term: #{@search}"
    Rails.logger.debug "Category ID: #{@featured_listing.category_id}"

    # Build query in steps for debugging
    @items = klass.published
    Rails.logger.debug "After published scope: #{@items.to_sql}"

    # Exclude already featured items
    already_featured = FeaturedListing.where(featurable_type: @type).pluck(:featurable_id)
    @items = @items.where.not(id: already_featured) if already_featured.any?
    Rails.logger.debug "After excluding featured: #{@items.to_sql}"

    # Add search condition if present
    if @search.present?
      @items = @items.where(
        "LOWER(#{klass.table_name}.name) ILIKE :search OR LOWER(#{klass.table_name}.description) ILIKE :search",
        search: "%#{@search.downcase}%"
      )
      Rails.logger.debug "After search condition: #{@items.to_sql}"
    end

    @items = @items.distinct

    # For each item, check if it belongs to the correct category
    @items = @items.map do |item|
      item_categories = item.categories.pluck(:id) + item.categorizables.pluck(:category_id)
      item.instance_variable_set(:@category_matches, item_categories.include?(@featured_listing.category_id))
      item.define_singleton_method(:category_matches?) { @category_matches }
      item
    end

    # Log final count
    Rails.logger.debug "Final item count: #{@items.count}"

    respond_to do |format|
      format.html
      format.turbo_stream
    end
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
