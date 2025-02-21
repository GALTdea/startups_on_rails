class CompaniesController < ApplicationController
  before_action :set_company, only: [ :show ]

  def index
    @companies = Company.published
                         .includes(:tags, :categories)
                         .order(created_at: :desc)

    apply_search_filter
    apply_category_filter
    apply_tag_filter
  end

  def show
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
