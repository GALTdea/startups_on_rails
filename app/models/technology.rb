# Technology model for tracking technology stack information used by companies.
#
# Key features:
# - Categorized by technology type
# - Tracks popularity of technologies
# - Associated with companies directly (HABTM) and through join table
# - Associated with solutions directly (HABTM)
# - Offers scopes for filtering by category and popularity
#
# Used to represent programming languages, frameworks, tools, and other
# technical components that companies use in their products and services.
class Technology < ApplicationRecord
  # Legacy associations - will be deprecated
  has_many :company_technologies, dependent: :destroy
  has_many :companies_through_join, through: :company_technologies, source: :companies

  # New direct HABTM association
  has_and_belongs_to_many :companies
  has_and_belongs_to_many :solutions

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true

  scope :by_category, -> { order(:category, :name) }
  scope :popular, -> { order(popularity: :desc) }
end
