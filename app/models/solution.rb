class Solution < ApplicationRecord
  has_one_attached :logo

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :website, presence: true
  validates :solution_type, presence: true
  validates :deployment_type, presence: true

  scope :published, -> { where(published: true) }
  scope :popular, -> { order(popularity: :desc) }
  scope :by_type, ->(type) { where(solution_type: type) if type.present? }
  scope :by_deployment, ->(deployment) { where(deployment_type: deployment) if deployment.present? }

  scope :search, ->(term) {
    where("solutions.name ILIKE :term OR solutions.description ILIKE :term", term: "%#{term}%")
  }

  # Solution types
  SOLUTION_TYPES = [
    "SaaS",
    "On-Premise",
    "Mobile App",
    "Desktop Application",
    "Framework",
    "Library",
    "API Service",
    "Hardware",
    "Hybrid"
  ].freeze

  # Deployment types
  DEPLOYMENT_TYPES = [
    "Cloud",
    "Self-hosted",
    "Hybrid",
    "Mobile",
    "Desktop"
  ].freeze
end
