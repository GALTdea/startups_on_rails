class WizardRecommendation < ApplicationRecord
  belongs_to :wizard_session
  belongs_to :solution
end
