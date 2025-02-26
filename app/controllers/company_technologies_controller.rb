class CompanyTechnologiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :authorize_company_edit!

  def edit
    @technologies = Technology.by_category
    @company_technologies = @company.company_technologies.includes(:technology)
  end

  def update
    # Remove existing technologies not in the new selection
    technology_ids = params[:company][:technology_ids].reject(&:blank?).map(&:to_i)
    @company.company_technologies.where.not(technology_id: technology_ids).destroy_all

    # Add new technologies
    technology_ids.each do |tech_id|
      unless @company.company_technologies.exists?(technology_id: tech_id)
        @company.company_technologies.create(technology_id: tech_id)
      end
    end

    # Update proficiency levels if provided
    if params[:proficiency_levels].present?
      params[:proficiency_levels].each do |tech_id, level|
        company_tech = @company.company_technologies.find_by(technology_id: tech_id)
        company_tech&.update(proficiency_level: level)
      end
    end

    redirect_to @company, notice: "Tech stack updated successfully"
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def authorize_company_edit!
    # Implement your authorization logic here
    # For example:
    # redirect_to @company, alert: 'Not authorized' unless current_user.can_edit?(@company)
  end
end
