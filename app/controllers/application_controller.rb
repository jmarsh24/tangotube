class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  after_action :track_action

  def signed_in_root_path(_resource_or_scope)
    root_path # or some other URL/path in your app
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  private

  def track_action
    ahoy.track 'Ran action', request.params
  end
end
