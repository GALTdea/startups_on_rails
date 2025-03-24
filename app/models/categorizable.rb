# Categorizable join model implementing a polymorphic categorization system.
#
# Key features:
# - Polymorphic association connecting categories to any categorizable resource
# - Ensures unique category associations per resource
# - Scope for filtering by category type
#
# This model enables the flexible categorization of different resource types
# (like Company, Solution) with Category records, replacing the legacy direct
# associations with a more flexible system.
class Categorizable < ApplicationRecord
  belongs_to :categorizable, polymorphic: true
  belongs_to :category

  validates :categorizable_id, uniqueness: { scope: [ :categorizable_type, :category_id ] }

  # Scopes
  scope :by_category_type, ->(type) { joins(:category).where(categories: { category_type: type }) if type.present? }
end
