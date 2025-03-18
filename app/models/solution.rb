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

  # Scopes for filtering by category
  scope :by_category, ->(category_ids) {
    return if category_ids.blank? || category_ids.reject(&:blank?).empty?

    joins(:categorizables)
      .where(categorizables: { category_id: category_ids.reject(&:blank?) })
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
end
