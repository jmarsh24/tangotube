# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def new
    flash[:notice] = "This is a test flash message."
  end

  def update_resource(resource, params)
    if resource.provider == "google_oauth2"
      params.delete("current_password")
      resource.password = params["password"]
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
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
