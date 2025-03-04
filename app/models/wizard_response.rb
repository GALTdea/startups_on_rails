class WizardResponse < ApplicationRecord
  belongs_to :wizard_session
  belongs_to :wizard_question
end
