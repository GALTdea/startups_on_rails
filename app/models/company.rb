class Company < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "user_id", optional: true

  validates :name, :description, :website, presence: true
  validates :slug, uniqueness: true
  validate :require_owner_unless_admin

  scope :published, -> { where(published: true) }

  private

  def require_owner_unless_admin
    return if user_id.present? || created_by_admin?

    errors.add(:user_id, "must be present for non-admin created companies")
  end

  def created_by_admin
    @created_by_admin ||= User.current.admin?
  end
end
