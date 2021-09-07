class ApplicationController < ActionController::Base
  protect_from_forgery
  after_action :track_action
  before_action :set_total_videos_count

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  private

  def set_total_videos_count
    @videos_total = Video.not_hidden.size
  end

  def track_action
    ahoy.track "Ran action", request.params
  end
  
end
