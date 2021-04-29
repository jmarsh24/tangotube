class ApplicationController < ActionController::Base
  protect_from_forgery
  after_action :track_action
  before_action :set_total_videos_count

  private

  def set_total_videos_count
    @videos_total = Video.not_hidden.size
  end

  def track_action
    ahoy.track 'Ran action', request.params
  end
end
