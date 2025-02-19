class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!

  def index
    @stats = {
      total_companies: Company.count,
      recent_companies: Company.where("created_at >= ?", 1.week.ago).count,
      pending_approvals: Company.where(published: false).count,
      user_counts: {
        admins: User.admin.count,
        company_owners: User.company_owners.count
      }
    }
  end

  private

  def authenticate_admin!
    return if current_user.admin?

    redirect_to root_path, alert: "Not authorized!"
  end
end
