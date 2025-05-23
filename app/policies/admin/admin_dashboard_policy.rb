module Admin
  class AdminDashboardPolicy < ApplicationPolicy
    def index?
      user.admin?
    end

    def show?
      admin?
    end

    def create?
      admin?
    end

    def new?
      create?
    end

    def update?
      admin?
    end

    def edit?
      update?
    end

    def destroy?
      admin?
    end

    private

    def admin?
      user.admin?
    end
  end
end
