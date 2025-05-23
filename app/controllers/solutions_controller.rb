class SolutionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_solution, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  def index
    @solutions = Solution.published.order(popularity: :desc)

    # Load categories for filtering
    @root_categories = Category.roots.includes(:children).order(:category_type, :name)
    @category_types = Category::CATEGORY_TYPES.map { |type| [ type.humanize, type ] }

    # Load technologies for filtering
    @technologies = Technology.order(:name)

    # Prepare parameter arrays - handle nested arrays
    category_ids = params[:category_ids].present? ? Array(params[:category_ids]).flatten : []
    technology_ids = params[:technology_ids].present? ? Array(params[:technology_ids]).flatten : []

    # Add debug logging in development
    if Rails.env.development?
      Rails.logger.debug "Original category_ids param: #{params[:category_ids].inspect}"
      Rails.logger.debug "Processed category_ids: #{category_ids.inspect}"
    end

    # Filter by company
    @solutions = @solutions.by_company(params[:company_id]) if params[:company_id].present?

    # Filter by solution type
    @solutions = @solutions.by_type(params[:solution_type]) if params[:solution_type].present?

    # Filter by deployment type
    @solutions = @solutions.by_deployment(params[:deployment_type]) if params[:deployment_type].present?

    # Filter by categories
    @solutions = @solutions.by_category(category_ids) if category_ids.present?

    # Filter by category type
    @solutions = @solutions.by_category_type(params[:category_type]) if params[:category_type].present?

    # Filter by technology stack - handle case when technologies are missing
    if technology_ids.present? && Technology.exists?
      @solutions = @solutions.with_technology(technology_ids)
    end

    # New metadata filters
    @solutions = @solutions.by_target_audience(params[:target_audience]) if params[:target_audience].present?
    @solutions = @solutions.by_technical_complexity(params[:technical_complexity]) if params[:technical_complexity].present?
    @solutions = @solutions.by_support_level(params[:support_level]) if params[:support_level].present?
    @solutions = @solutions.by_geographical_availability(params[:geographical_availability]) if params[:geographical_availability].present?
    @solutions = @solutions.by_customer_size(params[:customer_size]) if params[:customer_size].present?

    # Search by term
    @solutions = @solutions.search(params[:search]) if params[:search].present?

    # Paginate results
    @pagy, @solutions = pagy(@solutions, items: 12)
  end

  def show
  end

  def new
    @solution = Solution.new
    @solution.company_id = params[:company_id] if params[:company_id].present?

    # Only allow creating solutions for companies the user owns or if admin
    if @solution.company_id.present?
      @company = Company.find(@solution.company_id)
      authorize_company!(@company)
    end
  end

  def create
    @solution = Solution.new(solution_params)

    # Ensure user can only create solutions for companies they own or if admin
    if @solution.company_id.present?
      @company = Company.find(@solution.company_id)
      authorize_company!(@company)
    end

    if @solution.save
      redirect_to @solution, notice: "Solution was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @solution.update(solution_params)
      redirect_to @solution, notice: "Solution was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @solution.destroy
    redirect_to solutions_url, notice: "Solution was successfully destroyed."
  end

  private

  def set_solution
    @solution = Solution.find(params[:id])
  end

  def solution_params
    params.require(:solution).permit(
      :name, :description, :website, :pricing,
      :solution_type, :deployment_type, :popularity,
      :published, :company_id, :logo,
      :target_audience, :technical_complexity, :support_level,
      :geographical_availability, :customer_size,
      category_ids: [], technology_ids: []
    )
  end

  def authorize_user!
    unless current_user.admin? || (current_user.id == @solution.company&.user_id)
      redirect_to solutions_path, alert: "You are not authorized to perform this action."
    end
  end

  def authorize_company!(company)
    unless current_user.admin? || (current_user.id == company.user_id)
      redirect_to solutions_path, alert: "You are not authorized to add solutions to this company."
    end
  end
end
