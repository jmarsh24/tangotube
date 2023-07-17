# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout false, only: [:new, :create]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def update_resource(resource, params)
    if params[:password].blank? && params[:password_confirmation].blank?
      resource.update_without_password(params)
    else
      resource.update(params)
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, :avatar)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar)
    end
  end
end
