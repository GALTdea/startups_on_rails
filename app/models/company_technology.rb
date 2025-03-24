# CompanyTechnology join model managing the association between Company and Technology.
#
# Key features:
# - Join table connecting companies to technology stack components
# - Tracks proficiency level for each technology (core, regular, occasional)
# - Ensures unique technology associations per company
#
# This model enables detailed tracking of a company's tech stack with
# additional metadata about how extensively each technology is used.
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
