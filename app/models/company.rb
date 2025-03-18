class Company < ApplicationRecord
  include Featurable
  belongs_to :owner, class_name: "User", foreign_key: "user_id", optional: true

  # Active Storage attachment
  has_one_attached :logo

  before_create :set_unpublished

  validates :name, :description, :website, presence: true
  # validates :slug, uniqueness: true
  validate :require_owner_unless_admin
  # validates :description, presence: true, length: { minimum: 20 }

  scope :published, -> { where(published: true) }
  scope :search, ->(term) {
    where("companies.name ILIKE :term OR companies.description ILIKE :term", term: "%#{term}%")
  }

  attr_accessor :created_by

  # Legacy tag association - will be deprecated
  has_and_belongs_to_many :tags

  # New polymorphic tagging
  has_many :taggables, as: :taggable, dependent: :destroy
  has_many :polymorphic_tags, through: :taggables, source: :tag

  # Legacy categories association - will be deprecated
  has_and_belongs_to_many :categories

  # New polymorphic categorization
  has_many :categorizables, as: :categorizable, dependent: :destroy
  has_many :polymorphic_categories, through: :categorizables, source: :category

  has_many :solutions, dependent: :nullify

  # Legacy validation - will be updated to use polymorphic categories
  validates :category_ids, presence: { message: "must have at least one category" }

  # Scopes for filtering by category
  scope :by_category, ->(category_ids) {
    return if category_ids.blank? || category_ids.reject(&:blank?).empty?

    joins(:categories)
      .where(categories: { id: category_ids.reject(&:blank?) })
      .distinct
  }

  # New scope for filtering by polymorphic categories
  scope :by_polymorphic_category, ->(category_ids) {
    return if category_ids.blank? || category_ids.reject(&:blank?).empty?

    joins(:categorizables)
      .where(categorizables: { category_id: category_ids.reject(&:blank?) })
      .distinct
  }

  # New scope for filtering by category type
  scope :by_category_type, ->(category_type) {
    return if category_type.blank?

    joins(categorizables: :category)
      .where(categories: { category_type: category_type })
      .distinct
  }

  # Method to add a category using the polymorphic association
  def add_category(category)
    categorizables.find_or_create_by(category: category)
  end

  # Method to remove a category using the polymorphic association
  def remove_category(category)
    categorizables.where(category: category).destroy_all
  end

  # Method to check if a company has a specific category
  def has_category?(category)
    categorizables.exists?(category: category)
  end

  # Method to get all categories of a specific type
  def categories_by_type(type)
    polymorphic_categories.where(category_type: type)
  end

  has_and_belongs_to_many :technologies

  # Tech stack related scopes
  scope :with_any_technologies, ->(technology_ids) {
    joins(:technologies)
      .where(technologies: { id: technology_ids })
      .distinct
  }

  scope :with_all_technologies, ->(technology_ids) {
    companies = joins(:technologies)
      .where(technologies: { id: technology_ids })
      .group("companies.id")
      .having("COUNT(DISTINCT technologies.id) = ?", technology_ids.size)

    where(id: companies)
  }

  # Optional: Add a scope for filtering by tech stack
  scope :with_tech_stacks, ->(tech_stacks) {
    joins(:technologies).where(technologies: { name: tech_stacks }).distinct
  }

  # Method to add a tag using the polymorphic association
  def add_tag(tag)
    taggables.find_or_create_by(tag: tag)
  end

  # Method to remove a tag using the polymorphic association
  def remove_tag(tag)
    taggables.where(tag: tag).destroy_all
  end

  # Method to check if a company has a specific tag
  def has_tag?(tag)
    taggables.exists?(tag: tag)
  end

  def self.search(query)
    where("name ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%")
  end

  private

  def set_unpublished
    self.published = false if published.nil?
  end

  def require_owner_unless_admin
    return if user_id.present? || created_by_admin?

    # Only add error if not being created by admin
    errors.add(:base, "Owner must be present for non-admin created companies") unless created_by_admin?
  end

  def created_by_admin?
    @created_by_admin ||= created_by&.admin?
  end
end
