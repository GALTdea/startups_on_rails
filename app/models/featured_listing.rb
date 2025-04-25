# FeaturedListing model for managing featured content on the platform.
#
# Key features:
# - Associates with a specific category for targeted featuring
# - Manages collection of featurable items (companies, solutions)
# - Supports time-limited featuring with expiration dates
# - Includes ordering and positioning of featured items
# - Comprehensive scopes for determining active, current, and featured listings
#
# This model powers the featured content displays across the platform,
# allowing for strategic promotion of selected companies and solutions.
class FeaturedListing < ApplicationRecord
  belongs_to :category

  has_many :featured_listing_items, dependent: :destroy
  has_many :featurables, through: :featured_listing_items, source: :featurable, source_type: "Company"
  has_many :featured_solutions, through: :featured_listing_items, source: :featurable, source_type: "Solution"

  # Validations
  validates :title, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scopes
  scope :active, -> { where(active: true) }
  scope :current, -> {
    where("featured_until IS NULL OR featured_until > ?", Time.current)
  }
  scope :by_position, -> { order(position: :asc) }
  scope :featured, -> { active.current.by_position }

  # Class methods. returns a list of featured items by category type
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

  def add_item(item)
    featured_listing_items.create!(featurable: item)
  end

  def remove_item(item)
    featured_listing_items.find_by(featurable: item)&.destroy
  end

  def reorder_items(item_ids)
    item_ids.each_with_index do |id, index|
      featured_listing_items.find_by(featurable_id: id)&.update!(position: index + 1)
    end
  end

  # Overrides the has_many :featured_listing_items association to use manually loaded items when available
  def featured_listing_items_with_manual_loading
    items = instance_variable_get(:@featured_listing_items)
    return items if items

    # Fall back to the regular association
    featured_listing_items_without_manual_loading
  end

  # Create method aliases to override the association method
  alias_method :featured_listing_items_without_manual_loading, :featured_listing_items
  alias_method :featured_listing_items, :featured_listing_items_with_manual_loading
end
