class Admin::FeaturedListingsController < Admin::BaseController
  before_action :set_featured_listing, only: [ :show, :edit, :update, :destroy ]

  def index
    @featured_listings = FeaturedListing.includes(:category).order(position: :asc)
  end

  def show
  end

  def new
    @featured_listing = FeaturedListing.new
    @categories = Category.order(:category_type, :name)
  end

  def create
    @featured_listing = FeaturedListing.new(featured_listing_params)

    if @featured_listing.save
      redirect_to admin_featured_listings_path, notice: "Featured listing was successfully created."
    else
      @categories = Category.order(:category_type, :name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.order(:category_type, :name)
  end

  def update
    if @featured_listing.update(featured_listing_params)
      redirect_to admin_featured_listings_path, notice: "Featured listing was successfully updated."
    else
      @categories = Category.order(:category_type, :name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @featured_listing.destroy
    redirect_to admin_featured_listings_path, notice: "Featured listing was successfully deleted."
  end

  private

  def set_featured_listing
    @featured_listing = FeaturedListing.find(params[:id])
  end

  def featured_listing_params
    params.require(:featured_listing).permit(:title, :description, :category_id, :position, :active, :featured_until)
  end
end
