require "ostruct"

class Admin::FeaturableItemsController < Admin::BaseController
  before_action :set_featured_listing
  before_action :fetch_featurable_items, only: [ :index ]

  def index
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    items = params[:item_ids].map do |item_id|
      type, id = item_id.split(",")
      type.constantize.find(id)
    end

    items.each do |item|
      @featured_listing.add_item(item)
    end

    flash[:notice] = "Items added successfully"
    redirect_to admin_featured_listing_path(@featured_listing)
  end

  def destroy
    item = params[:type].constantize.find(params[:id])
    @featured_listing.remove_item(item)
    flash[:notice] = "Item removed successfully"
    redirect_to admin_featured_listing_path(@featured_listing)
  end

  private

  def set_featured_listing
    @featured_listing = FeaturedListing.find(params[:featured_listing_id])
  end

  def fetch_featurable_items
    @featurable_items = []

    # Get already featured items
    featured_item_ids = @featured_listing.featured_listing_items.pluck(:featurable_id)

    # Build the base query
    if params[:type].present?
      type = params[:type]
      query = "SELECT id, name, description, '#{type}' as item_type FROM #{type.tableize}"
    else
      query = <<-SQL
        SELECT id, name, description, 'Company' as item_type FROM companies
        UNION ALL
        SELECT id, name, description, 'Solution' as item_type FROM solutions
      SQL
    end

    # Add WHERE clause for filtering
    conditions = []
    query_params = {}

    if params[:search].present?
      conditions << "name ILIKE :search"
      query_params[:search] = "%#{params[:search]}%"
    end

    if featured_item_ids.any?
      conditions << "id NOT IN (:featured_ids)"
      query_params[:featured_ids] = featured_item_ids
    end

    if conditions.any?
      query += " WHERE " + conditions.join(" AND ")
    end

    # Execute the query
    @featurable_items = ActiveRecord::Base.connection.execute(
      ActiveRecord::Base.send(:sanitize_sql_array, [ query, query_params ])
    ).to_a
  end
end
