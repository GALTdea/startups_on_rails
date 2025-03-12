class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_stats
  layout "admin"

  private

  def authenticate_admin!
    return if current_user&.admin?

    redirect_to root_path, alert: "Not authorized!"
  end

  def set_admin_stats
    @stats = {
      pending_approvals: Company.where(published: false).count
    }
  end
end
