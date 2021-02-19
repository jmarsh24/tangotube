class WatchController < ApplicationController
  before_action :set_video, only: :show

  def show
    @videos_total = Video.all.size
    @recommended_videos = Video.where(song_id: @video.song_id).where.not(youtube_id: @video.youtube_id).order('popularity DESC').limit(3)
    @video.clicked!
  end

  def edit
    @video = Video.find_by(id: params[:id])
    @leader_options = Leader.all.pluck(:name, :id)
    @follower_options = Follower.all.pluck(:name, :id)
    @song_options = Song.all.map { |song| [song.full_title, song.id] }
    @event_options = Event.all.pluck(:title, :id)
  end

  private

  def set_video
    @video = Video.find_by(youtube_id: params[:v])
  end
end
