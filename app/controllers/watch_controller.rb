class WatchController < ApplicationController
  def show
    @active_video = Video.find_by(youtube_id: params[:v])
  end
end
