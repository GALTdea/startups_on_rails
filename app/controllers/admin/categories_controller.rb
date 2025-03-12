class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [ :edit, :update, :destroy ]

  def index
    @categories = Category.includes(:parent).order(:category_type, :name)
    @category = Category.new
    @category_types = Category::CATEGORY_TYPES
    @parent_categories = Category.order(:name)
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "Category created successfully"
    else
      @categories = Category.includes(:parent).order(:category_type, :name)
      @category_types = Category::CATEGORY_TYPES
      @parent_categories = Category.where.not(id: @category.id).order(:name)
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @category_types = Category::CATEGORY_TYPES
    @parent_categories = Category.where.not(id: @category.id).where.not(id: @category.all_children.map(&:id)).order(:name)
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Category updated successfully"
    else
      @category_types = Category::CATEGORY_TYPES
      @parent_categories = Category.where.not(id: @category.id).where.not(id: @category.all_children.map(&:id)).order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      redirect_to admin_categories_path, notice: "Category deleted successfully"
    else
      redirect_to admin_categories_path, alert: "Cannot delete category with associated resources"
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :slug, :description, :category_type, :parent_id)
  end
end
