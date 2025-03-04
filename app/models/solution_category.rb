class SolutionCategory < ApplicationRecord
  has_and_belongs_to_many :solutions

  validates :name, presence: true, uniqueness: true

  has_one_attached :icon

  scope :ordered, -> { order(position: :asc) }
  scope :with_solutions, -> { joins(:solutions).where(solutions: { published: true }).distinct }

  def solution_count
    solutions.published.count
  end
end
