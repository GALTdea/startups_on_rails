class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [ :show, :edit, :update ]

  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :role)
  end
end
