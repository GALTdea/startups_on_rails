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
