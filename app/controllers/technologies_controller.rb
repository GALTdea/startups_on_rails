class TechnologiesController < ApplicationController
  before_action :authenticate_admin!, except: [ :index, :show ]
  before_action :set_technology, only: [ :show, :edit, :update, :destroy ]

  def index
    @technologies = Technology.all

    if params[:category].present?
      @technologies = @technologies.where(category: params[:category])
    end

    @technologies = @technologies.by_category
  end

  def show
    @companies = @technology.companies.order(:name)
  end

  def new
    @technology = Technology.new
  end

  def create
    @technology = Technology.new(technology_params)

    if @technology.save
      redirect_to technologies_path, notice: "Technology was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @technology.update(technology_params)
      redirect_to technologies_path, notice: "Technology was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @technology.destroy
    redirect_to technologies_path, notice: "Technology was successfully deleted."
  end

  private

  def set_technology
    @technology = Technology.find(params[:id])
  end

  def technology_params
    params.require(:technology).permit(:name, :category, :popularity, :logo_url)
  end

  def authenticate_admin!
    # Implement your admin authentication logic here
    # For example:
    # redirect_to root_path, alert: 'Not authorized' unless current_user&.admin?
  end
end
