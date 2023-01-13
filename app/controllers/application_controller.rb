# frozen_string_literal: true

class ApplicationController < ActionController::Base
  newrelic_ignore_enduser
  include Pundit::Authorization
  include Shimmer::Consent
  include Shimmer::RemoteNavigation
  before_action :total_videos_count
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pagy::Backend

  default_form_builder Shimmer::Form::Builder

  private

  def total_videos_count
    @videos_total = Video.not_hidden.size
  end

  def track_action
    ahoy.track "Ran action", request.params
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :email, :password, :current_password)
    end
  end
end
