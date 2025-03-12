class Admin::DashboardController < Admin::BaseController
  after_action :verify_authorized

  def index
    authorize :dashboard, policy_class: Admin::DashboardPolicy
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
end
