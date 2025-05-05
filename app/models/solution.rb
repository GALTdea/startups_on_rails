# Solution model representing software or hardware products/services offered by companies.
#
# Key features:
# - Can be associated with a company
# - Categorized by solution_type and deployment_type
# - Uses polymorphic categorization and tagging
# - Can be featured in listings
# - Tracks popularity
# - Provides extensive filtering options
#
# Solutions are classified by:
# - Solution types (SaaS, Mobile App, API Service, etc.)
# - Deployment types (Cloud, Self-hosted, Mobile, etc.)
class Solution < ApplicationRecord
  include Featurable
  belongs_to :company, optional: true

  has_one_attached :logo

  # Polymorphic categorization
  has_many :categorizables, as: :categorizable, dependent: :destroy
  has_many :categories, through: :categorizables, source: :category

  # Polymorphic tagging
  has_many :taggables, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggables, source: :tag

  has_and_belongs_to_many :technologies

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :website, presence: true
  validates :solution_type, presence: true
  validates :deployment_type, presence: true

  scope :published, -> { where(published: true) }
  scope :popular, -> { order(popularity: :desc) }
  scope :by_type, ->(type) { where(solution_type: type) if type.present? }
  scope :by_deployment, ->(deployment) { where(deployment_type: deployment) if deployment.present? }
  scope :by_company, ->(company_id) { where(company_id: company_id) if company_id.present? }

  # Solution types
  SOLUTION_TYPES = [
    "SaaS",
    "On-Premise",
    "Mobile App",
    "Desktop Application",
    "Framework",
    "Library",
    "API Service",
    "Hardware",
    "Hybrid"
  ].freeze

  # Deployment types
  DEPLOYMENT_TYPES = [
    "Cloud",
    "Self-hosted",
    "Hybrid",
    "Mobile",
    "Desktop"
  ].freeze

  # Custom metadata fields with constants and validation

  # Target audience options
  TARGET_AUDIENCE = {
    "audience_technical_users" => "Technical Users (Developers, IT)",
    "audience_non_technical_users" => "Non-technical Users (Founders, Business Users)",
    "audience_marketing_teams" => "Marketing/Sales Teams",
    "audience_operations_teams" => "Operations Teams",
    "audience_hr_admin_teams" => "HR & Administrative Teams",
    "audience_legal_compliance_teams" => "Legal/Compliance Teams",
    "audience_general_entrepreneurs" => "General Entrepreneurs"
  }.freeze

  # Technical complexity options
  TECHNICAL_COMPLEXITY = {
    "complexity_no_code" => "No-code",
    "complexity_low_code" => "Low-code",
    "complexity_technical" => "Technical (requires developers)"
  }.freeze

  # Support level options
  SUPPORT_LEVEL = {
    "support_self_service" => "Self-service documentation",
    "support_email_chat" => "Email/chat support",
    "support_dedicated_account" => "Dedicated account management",
    "support_enterprise_support" => "24/7 Enterprise support"
  }.freeze

  # Geographical availability options
  GEOGRAPHICAL_AVAILABILITY = {
    "geo_global" => "Global",
    "geo_north_america" => "North America only",
    "geo_europe" => "Europe only",
    "geo_asia_pacific" => "Asia-Pacific only",
    "geo_latin_america" => "Latin America only",
    "geo_custom_regions" => "Custom regions (see description)"
  }.freeze

  # Customer size options
  CUSTOMER_SIZE = {
    "size_solo" => "Solo/Individual",
    "size_startup" => "Startup (1–10)",
    "size_small" => "SMB (11–50)",
    "size_medium" => "Medium (51–250)",
    "size_large" => "Large (250+)",
    "size_enterprise" => "Enterprise (1000+)"
  }.freeze

  # Scopes for the custom metadata fields
  scope :by_target_audience, ->(audience) { where(target_audience: audience) if audience.present? }
  scope :by_technical_complexity, ->(complexity) { where(technical_complexity: complexity) if complexity.present? }
  scope :by_support_level, ->(support) { where(support_level: support) if support.present? }
  scope :by_geographical_availability, ->(geo) { where(geographical_availability: geo) if geo.present? }
  scope :by_customer_size, ->(size) { where(customer_size: size) if size.present? }

  # Class methods to access the enum mappings
  def self.target_audience
    TARGET_AUDIENCE
  end

  def self.technical_complexity
    TECHNICAL_COMPLEXITY
  end

  def self.support_level
    SUPPORT_LEVEL
  end

  def self.geographical_availability
    GEOGRAPHICAL_AVAILABILITY
  end

  def self.customer_size
    CUSTOMER_SIZE
  end

  # Add validation for metadata fields
  validates :target_audience, inclusion: { in: TARGET_AUDIENCE.keys, allow_blank: true }
  validates :technical_complexity, inclusion: { in: TECHNICAL_COMPLEXITY.keys, allow_blank: true }
  validates :support_level, inclusion: { in: SUPPORT_LEVEL.keys, allow_blank: true }
  validates :geographical_availability, inclusion: { in: GEOGRAPHICAL_AVAILABILITY.keys, allow_blank: true }
  validates :customer_size, inclusion: { in: CUSTOMER_SIZE.keys, allow_blank: true }

  # Helper methods to get human-readable values for metadata fields
  def target_audience_name
    TARGET_AUDIENCE[target_audience] if target_audience.present?
  end

  def technical_complexity_name
    TECHNICAL_COMPLEXITY[technical_complexity] if technical_complexity.present?
  end

  def support_level_name
    SUPPORT_LEVEL[support_level] if support_level.present?
  end

  def geographical_availability_name
    GEOGRAPHICAL_AVAILABILITY[geographical_availability] if geographical_availability.present?
  end

  def customer_size_name
    CUSTOMER_SIZE[customer_size] if customer_size.present?
  end

  # Scopes for filtering by category
  scope :by_category, ->(category_ids) {
    return if category_ids.blank? || (category_ids.respond_to?(:reject) && category_ids.reject(&:blank?).empty?)

    # Handle possibly nested arrays by flattening
    flat_ids = if category_ids.is_a?(Array)
                 category_ids.flatten.compact.reject(&:blank?)
    else
                 [ category_ids ].compact.reject(&:blank?)
    end

    return if flat_ids.empty?

    # Convert to integers
    int_ids = flat_ids.map { |id| id.to_s.to_i }.reject(&:zero?)
    return if int_ids.empty?

    joins(:categorizables)
      .where(categorizables: { category_id: int_ids })
      .distinct
  }

  # Scope for filtering by category type
  scope :by_category_type, ->(category_type) {
    return if category_type.blank?

    joins(categorizables: :category)
      .where(categories: { category_type: category_type })
      .distinct
  }

  scope :search, ->(term) {
    where("solutions.name ILIKE :term OR solutions.description ILIKE :term", term: "%#{term}%")
  }

  # Add scopes for tech stack filtering
  scope :with_technology, ->(technology_ids) {
    return if technology_ids.blank? || (technology_ids.respond_to?(:reject) && technology_ids.reject(&:blank?).empty?)

    # Handle possibly nested arrays by flattening
    flat_ids = if technology_ids.is_a?(Array)
                 technology_ids.flatten.compact.reject(&:blank?)
    else
                 [ technology_ids ].compact.reject(&:blank?)
    end

    return if flat_ids.empty?

    # Convert to integers
    int_ids = flat_ids.map { |id| id.to_s.to_i }.reject(&:zero?)
    return if int_ids.empty?

    joins(:technologies)
      .where(technologies: { id: int_ids })
      .distinct
  }

  # Methods for managing categories
  def add_category(category)
    categorizables.find_or_create_by(category: category)
  end

  def remove_category(category)
    categorizables.where(category: category).destroy_all
  end

  def has_category?(category)
    categorizables.exists?(category: category)
  end

  def categories_by_type(type)
    categories.where(category_type: type)
  end

  # Methods for managing tags
  def add_tag(tag)
    taggables.find_or_create_by(tag: tag)
  end

  def remove_tag(tag)
    taggables.where(tag: tag).destroy_all
  end

  def has_tag?(tag)
    taggables.exists?(tag: tag)
  end

  def self.search(query)
    where("name ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%")
  end

  # Helper methods for technologies
  def add_technology(technology)
    technologies << technology unless technologies.include?(technology)
  end

  def remove_technology(technology)
    technologies.delete(technology)
  end
end
