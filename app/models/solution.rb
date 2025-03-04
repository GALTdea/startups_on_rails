class Solution < ApplicationRecord
  belongs_to :company

  validates :name, presence: true
  validates :description, presence: true
  validates :website, presence: true, format: { with: URI.regexp(%w[http https]), message: "must be a valid URL" }
  validates :pricing, presence: true
  validates :deployment_type, presence: true
  validates :solution_type, presence: true
  validates :popularity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
