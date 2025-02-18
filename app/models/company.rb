class Company < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "user_id"


  validates :name, :description, :website, presence: true
  validates :slug, uniqueness: true

  scope :published, -> { where(published: true) }
end
