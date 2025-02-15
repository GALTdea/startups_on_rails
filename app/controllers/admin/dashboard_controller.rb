class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!

  def index
    # Admin dashboard logic
  end

  private

  def authenticate_admin!
    return if current_user.admin?

    redirect_to root_path, alert: "Not authorized!"
  end
end
