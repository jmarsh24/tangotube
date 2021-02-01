class WatchController < ApplicationController
  def show
    @videos_total = Video.all
    @active_video = Video.find_by(youtube_id: params[:v])
    @active_video.update(popularity: @active_video.popularity + 1)
  end
end
