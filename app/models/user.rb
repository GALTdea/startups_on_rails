class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum :role, {
    member: 0,        # Regular community member
    company_owner: 1, # Tech company representative
    admin: 2          # Platform administrator
  }

  after_initialize :set_default_role, if: :new_record?

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :role_assignment_permission, on: :create

  # Add this scope
  scope :company_owners, -> { where(role: :company_owner) }

  private

  def set_default_role
    self.role ||= :member  # Set your default role here
  end

  def role_assignment_permission
    return unless role_changed? && !persisted?

    # Skip validation during seeding or when no current_user is available
    return if Rails.env.development? && defined?(Rails::Console) ||
              defined?(Rails::Command) && Rails.const_defined?("Server") ||
              defined?(Rake) ||
              !defined?(current_user)

    if User.roles[role] > User.roles[:member] && !current_user&.admin?
      errors.add(:role, "assignment not permitted")
    end
  end
end
