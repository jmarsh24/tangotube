# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  private

  def after_confirmation_path_for(_resource_name, resource)
    sign_in(resource)
    redirect_to root_path
  end
end
