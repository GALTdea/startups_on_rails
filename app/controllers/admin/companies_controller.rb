class Admin::CompaniesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_admin!
  before_action :set_company, only: [ :show, :edit, :update, :destroy ]

  def index
    @companies = Company.all.order(created_at: :desc)

    # Apply search if present
    if params[:search].present?
      @companies = @companies.where("name ILIKE :search OR description ILIKE :search",
                                  search: "%#{params[:search]}%")
    end

    # Apply status filter
    @companies = case params[:status]
    when "published"
                   @companies.where(published: true)
    when "draft"
                   @companies.where(published: false)
    else
                   @companies
    end

    # Apply date filter
    @companies = case params[:date]
    when "today"
                   @companies.where("created_at >= ?", Date.today)
    when "week"
                   @companies.where("created_at >= ?", 1.week.ago)
    when "month"
                   @companies.where("created_at >= ?", 1.month.ago)
    else
                   @companies
    end
  end

  def show
  end

  def new
    @company = Company.new
    @users = User.company_owners
  end

  def edit
  end

  def create
    @company = Company.new(company_params)
    @company.created_by = current_user
    @company.published = true if current_user.admin? # Auto-publish if admin creates

    respond_to do |format|
      if @company.save
        format.html { redirect_to admin_companies_path, notice: "Company created successfully." }
        format.turbo_stream { redirect_to admin_companies_path }
      else
        @users = User.company_owners if current_user.admin?
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("company_form", partial: "form", locals: { company: @company }) }
      end
    end
  end

  def update
    @company.created_by = current_user
    if @company.update(company_params)
      respond_to do |format|
        format.html { redirect_to admin_companies_path, notice: "Company #{@company.published? ? 'published' : 'unpublished'} successfully." }
        format.turbo_stream {
          flash.now[:notice] = "Company #{@company.published? ? 'published' : 'unpublished'} successfully."
          render turbo_stream: turbo_stream.replace("#{dom_id(@company)}_status", partial: "status", locals: { company: @company })
        }
      end
    else
      render :edit
    end
  end

  def destroy
    @company.destroy
    redirect_to admin_companies_path(pending: true), notice: "Company rejected successfully."
  end

  private

  def company_params
    params.require(:company).permit(
      :name, :description, :website, :location,
      :slug, :published, :user_id, # Allow admin to set owner
      tag_ids: [], category_ids: []
    )
  end

  def authenticate_admin!
    return if current_user.admin? || current_user.company_owner?

    redirect_to root_path, alert: "Not authorized!"
  end

  def set_company
    @company = Company.find(params[:id])
  end
end
