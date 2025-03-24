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

  before_validation :normalize_name

  private

  def normalize_name
    self.name = name.downcase.strip if name.present?
  end
end
