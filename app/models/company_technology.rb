class CompanyTechnology < ApplicationRecord
  belongs_to :company
  belongs_to :technology

  validates :company_id, uniqueness: { scope: :technology_id }

  enum :proficiency_level, {
    core: "core",
    regular: "regular",
    occasional: "occasional"
  }, default: "regular"
end
