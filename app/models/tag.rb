# Tag model for implementing a flexible tagging system.
#
# Key features:
# - Simple tag storage with name normalization (lowercase, strip)
# - Polymorphic association for flexible tagging of different resource types
# - Legacy direct association with companies (being deprecated)
#
# Used to tag companies, solutions, and other resources for better
# search, filtering, and discovery capabilities.
class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # Legacy association - will be deprecated in favor of polymorphic association
  has_and_belongs_to_many :companies

  # Polymorphic association
  has_many :taggables, dependent: :destroy
  # Taggable is used to tag companies, solutions, technologies, and other resources.
  # it allows a polymorphic association to be created between the tag and the resource it is tagged to.
  # Instead of having a separate table for each taggable type, or a separate column for each taggable type, we can use a single table for all taggables.
  # it also allows for the tag to be used in a search query. does so by using the taggable_type and taggable_id columns to find the taggable.

  before_validation :normalize_name

  private

  def normalize_name
    self.name = name.downcase.strip if name.present?
  end
end
