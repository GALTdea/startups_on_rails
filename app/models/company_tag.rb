# CompanyTag join model for the legacy direct association between Company and Tag.
#
# This is a simple join table being phased out in favor of the more
# flexible polymorphic Taggable model. It maintains existing tag
# associations until the transition is complete.
class CompanyTag < ApplicationRecord
  belongs_to :company
  belongs_to :tag
end
