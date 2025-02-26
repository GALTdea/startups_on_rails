class CompaniesController < ApplicationController
  before_action :set_company, only: [ :show ]

  def index
    @companies = Company.published
                       .includes(:tags, :categories)
                       .order(created_at: :desc)

    # Filter by industry categories
    if params[:industry_categories].present?
      @companies = @companies.joins(:categories)
                            .where(categories: { id: params[:industry_categories], category_type: "industry" })
    end

    # Filter by size categories
    if params[:size_categories].present?
      @companies = @companies.joins(:categories)
                            .where(categories: { id: params[:size_categories], category_type: "size" })
    end

    # Continue with existing filters
    @companies = @companies.by_tags(params[:tags])
                           .search(params[:search])
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
