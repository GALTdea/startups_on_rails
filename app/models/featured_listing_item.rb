# FeaturedListingItem join model connecting featured listings to featurable resources.
#
# Key features:
# - Polymorphic association with featurable resources (companies, solutions)
# - Manages positioning of items within a featured listing
# - Ensures unique items per listing
# - Automatically sets position for new items
#
# This model enables the organization and display order of multiple
# featured items within a single featured listing.
class FeaturedListingItem < ApplicationRecord
  belongs_to :featured_listing
  belongs_to :featurable, polymorphic: true

  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :featurable_id, uniqueness: { scope: [ :featured_listing_id, :featurable_type ],
    message: "has already been added to this listing" }

  before_validation :set_position, on: :create

  private

  def set_position
    self.position ||= featured_listing.featured_listing_items.maximum(:position).to_i + 1
  end
end
