# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  before_action :configure_sign_up_params, only: [ :create ]
  before_action :validate_role_assignment, only: [ :create ]

  def configure_sign_up_params
    # Only allow role param if current_user is admin
    if current_user&.admin?
      devise_parameter_sanitizer.permit(:sign_up, keys: [ :role ])
    else
      devise_parameter_sanitizer.permit(:sign_up, keys: [])
    end
  end

  def validate_role_assignment
    return unless params[:user][:role].present?
    return if current_user&.admin?

    self.resource = resource_class.new(sign_up_params)
    resource.errors.add(:role, "assignment not permitted")

    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity }
      format.turbo_stream { render turbo_stream: turbo_stream.replace(:error_messages, partial: "devise/shared/error_messages") }
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    if resource.company_owner?
      new_company_path
    else
      super
    end
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
