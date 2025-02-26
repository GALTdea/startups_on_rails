class Technology < ApplicationRecord
  has_many :company_technologies, dependent: :destroy
  has_many :companies, through: :company_technologies

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true

  scope :by_category, -> { order(:category, :name) }
  scope :popular, -> { order(popularity: :desc) }
end
