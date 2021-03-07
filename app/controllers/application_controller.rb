class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  after_action :track_action

  private

  def track_action
    ahoy.track "Ran action", request.params
  end
end
