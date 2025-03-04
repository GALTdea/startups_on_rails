class SolutionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_solution, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_company_owner, only: [ :new, :create, :edit, :update, :destroy ]

  def index
    @solutions = @company.solutions
  end

  def show
  end

  def new
    @solution = @company.solutions.build
  end

  def create
    @solution = @company.solutions.build(solution_params)

    if @solution.save
      redirect_to company_solution_path(@company, @solution), notice: "Solution was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @solution.update(solution_params)
      redirect_to company_solution_path(@company, @solution), notice: "Solution was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @solution.destroy
    redirect_to company_solutions_path(@company), notice: "Solution was successfully deleted."
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_solution
    @solution = @company.solutions.find(params[:id])
  end

  def solution_params
    params.require(:solution).permit(
      :name, :description, :website, :pricing,
      :deployment_type, :popularity, :solution_type
    )
  end

  def authorize_company_owner
    unless @company.owner == current_user || current_user.admin?
      redirect_to company_solutions_path(@company), alert: "You are not authorized to perform this action."
    end
  end
end
