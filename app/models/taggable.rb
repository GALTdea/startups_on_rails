# Taggable join model implementing a polymorphic tagging system.
#
# Key features:
# - Polymorphic association connecting tags to any taggable resource
# - Ensures unique tag associations per resource
#
# This model enables the flexible tagging of different resource types
# (like Company, Solution) with Tag records, replacing the legacy direct
# associations with a more flexible system.
class Taggable < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  belongs_to :tag

  validates :taggable_id, uniqueness: { scope: [ :taggable_type, :tag_id ] }
end
