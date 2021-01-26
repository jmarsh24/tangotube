class WatchController < ApplicationController
  def show
    @active_video = Video.find_by(youtube_id: params[:v])
    @active_video.update(popularity: @active_video.popularity + 1)
  end
end
