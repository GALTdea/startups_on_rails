class SolutionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_solution, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  def index
    @solutions = Solution.published.order(popularity: :desc)

    # Filter by company
    @solutions = @solutions.by_company(params[:company_id]) if params[:company_id].present?

    # Filter by solution type
    @solutions = @solutions.by_type(params[:solution_type]) if params[:solution_type].present?

    # Filter by deployment type
    @solutions = @solutions.by_deployment(params[:deployment_type]) if params[:deployment_type].present?

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
      :published, :company_id, :logo
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
