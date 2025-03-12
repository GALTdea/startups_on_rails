class Categorizable < ApplicationRecord
  belongs_to :categorizable, polymorphic: true
  belongs_to :category

  validates :categorizable_id, uniqueness: { scope: [ :categorizable_type, :category_id ] }

  # Scopes
  scope :by_category_type, ->(type) { joins(:category).where(categories: { category_type: type }) if type.present? }
end
