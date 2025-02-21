class CompaniesController < ApplicationController
  def index
    @companies = Company.published.order(created_at: :desc)

    if params[:search].present?
      @companies = @companies.search(params[:search])
    end

    if params[:category].present?
      @companies = @companies.joins(:categories).where(categories: { id: params[:category] })
    end

    if params[:tag].present?
      @companies = @companies.joins(:tags).where(tags: { id: params[:tag] })
    end
  end

  def show
  end
end
