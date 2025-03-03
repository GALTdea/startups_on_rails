class CompaniesController < ApplicationController
  before_action :set_company, only: [ :show ]

  def index
    @companies = Company.all

    # Filter by search term
    @companies = @companies.search(params[:search]) if params[:search].present?

    # Filter by industry
    @companies = @companies.where(industry: params[:industry]) if params[:industry].present?

    # Filter by tags
    @companies = @companies.joins(:tags).where(tags: { id: params[:tags] }).distinct if params[:tags].present?

    # Filter by tech stacks
    if params[:tech_stacks].present?
      @companies = @companies.joins(:technologies)
                            .where(technologies: { name: params[:tech_stacks] })
                            .distinct
    end

    # Order by created_at
    @companies = @companies.order(created_at: :desc)
  end

  def show
  end

  def search_by_tech_stack
    @technologies = Technology.by_category

    if params[:technology_ids].present?
      technology_ids = params[:technology_ids].reject(&:blank?)

      if params[:match_type] == "all"
        @companies = Company.published.with_all_technologies(technology_ids)
      else
        @companies = Company.published.with_any_technologies(technology_ids)
      end
    else
      @companies = Company.none
    end

    # If it's an AJAX request, render partial
    if request.xhr?
      render partial: "companies/company_list", locals: { companies: @companies }
    end
    # Otherwise the default view will be rendered
  end

  private

  def set_company
    @company = Company.published.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to companies_path, alert: "Company not found"
  end

  def apply_search_filter
    return unless params[:search].present?
    @companies = @companies.search(params[:search])
  end

  def apply_category_filter
    return unless params[:category].present?
    @companies = @companies.joins(:categories)
                          .where(categories: { id: params[:category] })
  end

  def apply_tag_filter
    return unless params[:tag].present?
    @companies = @companies.joins(:tags)
                          .where(tags: { id: params[:tag] })
  end
end
