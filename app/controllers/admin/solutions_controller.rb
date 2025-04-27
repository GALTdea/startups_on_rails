class Admin::SolutionsController < Admin::BaseController
  before_action :set_solution, only: [ :show, :edit, :update, :destroy ]

  def index
    @solutions = Solution.all.order(created_at: :desc)

    # Apply search if present
    if params[:search].present?
      @solutions = @solutions.where("name ILIKE :search OR description ILIKE :search",
                                  search: "%#{params[:search]}%")
    end

    # Apply status filter
    @solutions = case params[:status]
    when "published"
                   @solutions.where(published: true)
    when "draft"
                   @solutions.where(published: false)
    else
                   @solutions
    end

    # Apply date filter
    @solutions = case params[:date]
    when "today"
                   @solutions.where("created_at >= ?", Date.today)
    when "week"
                   @solutions.where("created_at >= ?", 1.week.ago)
    when "month"
                   @solutions.where("created_at >= ?", 1.month.ago)
    else
                   @solutions
    end
  end

  def show
  end

  def new
    @solution = Solution.new
  end

  def edit
  end

  def create
    @solution = Solution.new(solution_params)
    @solution.created_by = current_user if @solution.respond_to?(:created_by=)
    @solution.published = true if current_user.admin? # Auto-publish if admin creates

    respond_to do |format|
      if @solution.save
        format.html { redirect_to admin_solutions_path, notice: "Solution created successfully." }
        format.turbo_stream { redirect_to admin_solutions_path }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("solution_form", partial: "form", locals: { solution: @solution }) }
      end
    end
  end

  def update
    respond_to do |format|
      if @solution.update(solution_params)
        format.html { redirect_to admin_solution_path(@solution), notice: "Solution updated successfully." }
        format.turbo_stream { redirect_to admin_solution_path(@solution) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("solution_form", partial: "form", locals: { solution: @solution }) }
      end
    end
  end

  def destroy
    @solution.destroy
    redirect_to admin_solutions_path, notice: "Solution deleted successfully."
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
end
