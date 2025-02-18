class Admin::CompaniesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_company, only: [ :show, :edit, :update, :destroy ]

  def index
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
    @company.owner = current_user unless current_user.admin? # Only set owner if not admin

    if @company.save
      redirect_to admin_company_path(@company), notice: "Company was successfully created."
    else
      @users = User.company_owners if current_user.admin?
      render :new
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
end
