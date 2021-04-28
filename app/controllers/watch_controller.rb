class WatchController < ApplicationController
  before_action :set_video, only: :show

  def show
    @videos_total = Video.all.where(hidden: false).size

    @recommended_videos =
      Video
        .where(song_id: @video.song_id)
        .or
        .where(channel_id: @video.song_id)
        .where(hidden: false)
        .where
        .not(youtube_id: @video.youtube_id)
        .order('popularity DESC')
        .limit(3)
    @video.clicked!
  end

  def edit
    @video = Video.find_by(id: params[:id])
    @leader_options = Leader.all.order(:name).pluck(:name, :id)

    @follower_options = Follower.all.order(:name).pluck(:name, :id)

    @song_options =
      Song.all.order(:title).map { |song| [song.full_title, song.id] }

    @event_options = Event.all.order(:title).pluck(:title, :id)
  end

  private

  def set_video
    @video = Video.find_by(youtube_id: params[:v])
  end
end
