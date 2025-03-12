class CategoryFilterService
  attr_reader :params

  def initialize(params = {})
    @params = params
  end

  def filter_companies
    companies = Company.published

    # Filter by search term if provided
    if params[:search].present?
      companies = companies.search(params[:search])
    end

    # Filter by category types
    filter_by_category_types(companies)
  end

  def filter_solutions
    solutions = Solution.published

    # Filter by search term if provided
    if params[:search].present?
      solutions = solutions.search(params[:search])
    end

    # Filter by solution type if provided
    if params[:solution_type].present?
      solutions = solutions.by_type(params[:solution_type])
    end

    # Filter by deployment type if provided
    if params[:deployment_type].present?
      solutions = solutions.by_deployment(params[:deployment_type])
    end

    # Filter by category types
    filter_by_category_types(solutions)
  end

  private

  def filter_by_category_types(scope)
    # Start with the original scope
    filtered_scope = scope

    # Filter by industry categories if provided
    if params[:industry_categories].present?
      industry_ids = Array(params[:industry_categories]).reject(&:blank?)
      if industry_ids.any?
        filtered_scope = filtered_scope.joins(categorizables: :category)
          .where(categories: { id: industry_ids, category_type: "industry" })
          .distinct
      end
    end

    # Filter by technology categories if provided
    if params[:technology_categories].present?
      technology_ids = Array(params[:technology_categories]).reject(&:blank?)
      if technology_ids.any?
        filtered_scope = filtered_scope.joins(categorizables: :category)
          .where(categories: { id: technology_ids, category_type: "technology" })
          .distinct
      end
    end

    # Filter by problem domain categories if provided
    if params[:problem_domain_categories].present?
      problem_domain_ids = Array(params[:problem_domain_categories]).reject(&:blank?)
      if problem_domain_ids.any?
        filtered_scope = filtered_scope.joins(categorizables: :category)
          .where(categories: { id: problem_domain_ids, category_type: "problem_domain" })
          .distinct
      end
    end

    # Filter by job function categories if provided
    if params[:job_function_categories].present?
      job_function_ids = Array(params[:job_function_categories]).reject(&:blank?)
      if job_function_ids.any?
        filtered_scope = filtered_scope.joins(categorizables: :category)
          .where(categories: { id: job_function_ids, category_type: "job_function" })
          .distinct
      end
    end

    # Filter by tags if provided
    if params[:tags].present?
      tag_ids = Array(params[:tags]).reject(&:blank?)
      if tag_ids.any?
        filtered_scope = filtered_scope.joins(:taggables)
          .where(taggables: { tag_id: tag_ids })
          .distinct
      end
    end

    filtered_scope
  end
end
