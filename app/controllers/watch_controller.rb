class WatchController < ApplicationController
  def watch
    @active_video = Video.find_by(youtube_id: params[:v])
  end
end
