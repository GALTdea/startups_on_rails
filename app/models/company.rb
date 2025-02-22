class Company < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "user_id", optional: true

  before_create :set_unpublished

  validates :name, :description, :website, presence: true
  # validates :slug, uniqueness: true
  validate :require_owner_unless_admin
  # validates :description, presence: true, length: { minimum: 20 }

  scope :published, -> { where(published: true) }
  scope :search, ->(term) {
    where("companies.name ILIKE :term OR companies.description ILIKE :term", term: "%#{term}%")
  }

  attr_accessor :created_by

  has_and_belongs_to_many :tags
  has_and_belongs_to_many :categories

  validates :category_ids, presence: { message: "must have at least one category" },
                           length: { minimum: 1, maximum: 5 }

  scope :by_category, ->(category_ids) {
    return if category_ids.blank? || category_ids.reject(&:blank?).empty?

    joins(:categories)
      .where(categories: { id: category_ids.reject(&:blank?) })
      .distinct
  }

  scope :by_tags, ->(tag_ids) {
    return if tag_ids.blank? || tag_ids.reject(&:blank?).empty?

    joins(:tags)
      .where(tags: { id: tag_ids.reject(&:blank?) })
      .distinct
  }

  has_one_attached :logo

  private

  def set_unpublished
    self.published = false if published.nil?
  end

  def require_owner_unless_admin
    return if user_id.present? || created_by_admin?

    # Only add error if not being created by admin
    errors.add(:base, "Owner must be present for non-admin created companies") unless created_by_admin?
  end

  def created_by_admin?
    @created_by_admin ||= created_by&.admin?
  end
end
