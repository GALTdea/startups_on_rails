class FeaturedListing < ApplicationRecord
  belongs_to :category
  belongs_to :featurable, polymorphic: true, optional: true

  # Validations
  validates :title, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :featurable_id, uniqueness: { scope: :featurable_type,
    message: "has already been featured" }, allow_nil: true
  validate :featurable_category_matches

  # Scopes
  scope :active, -> { where(active: true) }
  scope :current, -> {
    where("featured_until IS NULL OR featured_until > ?", Time.current)
  }
  scope :by_position, -> { order(position: :asc) }
  scope :featured, -> { active.current.by_position }

  # Class methods
  def self.featured_by_category_type(category_type, limit = 5)
    joins(:category)
      .where(categories: { category_type: category_type })
      .featured
      .limit(limit)
  end

  # Instance methods
  def expired?
    featured_until.present? && featured_until <= Time.current
  end

  def days_remaining
    return nil if featured_until.blank?
    return 0 if expired?

    ((featured_until - Time.current) / 1.day).ceil
  end

  private

  def featurable_category_matches
    return unless featurable.respond_to?(:category_id) && category_id.present?

    unless featurable.category_id == category_id
      errors.add(:base, "Featured item must belong to the same category")
    end
  end
end
