class Company < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "user_id", optional: true

  before_create :set_unpublished

  validates :name, :description, :website, presence: true
  # validates :slug, uniqueness: true
  validate :require_owner_unless_admin
  # validates :description, presence: true, length: { minimum: 20 }

  scope :published, -> { where(published: true) }
  scope :search, ->(term) {
    where("name ILIKE :term OR description ILIKE :term", term: "%#{term}%")
  }

  attr_accessor :created_by

  has_and_belongs_to_many :tags
  has_and_belongs_to_many :categories

  validates :category_ids, presence: { message: "must have at least one category" },
                           length: { minimum: 1, maximum: 5 }

  scope :by_category, ->(category_id) {
    where(exists: CompanyCategory.select("1")
      .where("company_id = companies.id")
      .where(category_id: category_id)
    ) if category_id.present? }

  scope :by_tags, ->(tag_ids) {
    tag_ids.present? ? where(
      Tag.where(id: tag_ids)
         .where("EXISTS (SELECT 1 FROM companies_tags WHERE companies_tags.tag_id = tags.id AND companies_tags.company_id = companies.id)")
         .arel.exists
    ) : all
  }

  private

  def set_unpublished
    self.published = false if published.nil?
  end

  def require_owner_unless_admin
    Rails.logger.info "Validation check - Admin?: #{created_by_admin?}, User ID: #{user_id}"
    return if user_id.present? || created_by_admin?

    errors.add(:user_id, "must be present for non-admin created companies")
  end

  def created_by_admin?
    @created_by_admin ||= created_by&.admin?
  end
end
