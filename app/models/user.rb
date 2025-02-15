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

  private

  def set_default_role
    self.role ||= :member  # Set your default role here
  end

  def role_assignment_permission
    return unless role_changed? && !persisted?

    if User.roles[role] > User.roles[:member] && !User.current.admin?
      errors.add(:role, "assignment not permitted")
    end
  end
end
