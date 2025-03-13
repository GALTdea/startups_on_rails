class Category < ApplicationRecord
  # Self-referential associations for hierarchy
  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :nullify

  # Polymorphic association for categorizable resources
  has_many :categorizables, dependent: :destroy

  # Featured listings association
  has_many :featured_listings, dependent: :destroy

  # Legacy association - will be deprecated in favor of polymorphic association
  has_and_belongs_to_many :companies

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, uniqueness: true, allow_blank: true
  validates :category_type, presence: true
  validate :parent_cannot_be_self
  validate :prevent_circular_references

  # Callbacks
  before_validation :generate_slug, if: -> { slug.blank? && name.present? }
  before_validation :set_default_category_type, if: -> { category_type.blank? }

  # Scopes
  scope :roots, -> { where(parent_id: nil) }
  scope :by_type, ->(type) { where(category_type: type) if type.present? }

  # Category types
  CATEGORY_TYPES = %w[industry technology problem_domain job_function].freeze

  # Instance methods
  def ancestors
    return [] unless parent
    parent.ancestors + [ parent ]
  end

  def root?
    parent_id.nil?
  end

  def leaf?
    children.empty?
  end

  def depth
    ancestors.size
  end

  def breadcrumb
    ancestors.map(&:name) + [ name ]
  end

  def all_children
    children + children.flat_map(&:all_children)
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end

  def set_default_category_type
    self.category_type = "industry"
  end

  def parent_cannot_be_self
    errors.add(:parent_id, "cannot be self") if parent_id == id && !id.nil?
  end

  def prevent_circular_references
    if parent && (parent.ancestors.include?(self) || parent == self)
      errors.add(:parent_id, "would create a circular reference")
    end
  end
end
