# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def update_resource(resource, params)
    if params[:password].present? && params[:password_confirmation].present?
      resource.update_with_password(params)
    else
      params.delete("current_password")
      resource.password = params["password"] if params["password"].present?
      resource.update_without_password(params.except(:password, :password_confirmation))
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update,
      keys: [
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation,
        :avatar
      ])
  end
end
