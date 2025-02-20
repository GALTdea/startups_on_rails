class Admin::CompaniesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_company, only: [ :show, :edit, :update, :destroy ]

  def index
    @companies = Company.all.order(created_at: :desc)
    @companies = @companies.where(published: false) if params[:pending]
  end

  def show
  end

  def new
    @company = Company.new
    @users = User.company_owners if current_user.admin?
  end

  def edit
  end

  def create
    @company = Company.new(company_params)
    @company.created_by = current_user
    @company.owner = current_user unless current_user.admin?

    respond_to do |format|
      if @company.save
        format.html { redirect_to admin_company_path(@company), notice: "Company was successfully created." }
        format.turbo_stream { redirect_to admin_company_path(@company) }
      else
        @users = User.company_owners if current_user.admin?
        format.html { render :new }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("company_form", partial: "form", locals: { company: @company }) }
      end
    end
  end

  def update
  end

  def destroy
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
