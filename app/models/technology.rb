class Technology < ApplicationRecord
  # Legacy associations - will be deprecated
  has_many :company_technologies, dependent: :destroy
  has_many :companies_through_join, through: :company_technologies, source: :companies

  # New direct HABTM association
  has_and_belongs_to_many :companies

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true

  scope :by_category, -> { order(:category, :name) }
  scope :popular, -> { order(popularity: :desc) }
end
