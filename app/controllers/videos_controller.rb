class VideosController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :current_search, only: %i[index]
  before_action :set_video, only: %i[update edit]
  before_action :set_recommended_videos, only: %i[edit]

  helper_method :sorting_params, :filtering_params

  def index
    @search =
      Video::Search.for(
        filtering_params: filtering_params,
        sorting_params: sorting_params,
        page: page,
        user: current_user
      )
  end

  def edit; end

  def show
    @video = Video.find_by(youtube_id: show_params[:v])
    set_recommended_videos
    @video.clicked!
    ahoy.track("Video View", video_id: Video.find_by(youtube_id: show_params[:v]).id )
  end

  def update
    @video.update(video_params)
    redirect_to watch_path(v: @video.youtube_id)
  end

  def create
    @video = Video.create(youtube_id: params[:video][:youtube_id])
    fetch_new_video

    redirect_to root_path,
                notice:
                  "Video Sucessfully Added: The video must be approved before the videos are added"
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end

  def set_recommended_videos
    videos_from_this_performance
    videos_with_same_event
    videos_with_same_song
    videos_with_same_channel
  end

  def videos_from_this_performance
    @videos_from_this_performance = Video.where("upload_date <= ?", @video.upload_date + 7.days)
                                         .where("upload_date >= ?", @video.upload_date - 7.days)
                                         .where(channel_id: @video.channel_id)
                                         .where(leader_id: @video.leader_id)
                                         .where(follower_id: @video.follower_id)
                                         .order("performance_number ASC")
                                         .where(hidden: false)
                                         .where
                                         .not(youtube_id: @video.youtube_id)
                                         .limit(8)
  end

  def videos_with_same_event
    @videos_with_same_event = Video.where(event_id: @video.event_id)
                                   .where.not(event: nil)
                                   .where("upload_date <= ?", @video.upload_date + 7.days)
                                   .where("upload_date >= ?", @video.upload_date - 7.days)
                                   .where(hidden: false)
                                   .where.not(youtube_id: @video.youtube_id)
                                   .limit(8)
    @videos_with_same_event = @videos_with_same_event - @videos_from_this_performance
  end

  def videos_with_same_song
    @videos_with_same_song = Video.where(song_id: @video.song_id)
                                  .where(hidden: false)
                                  .where.not(youtube_id: @video.youtube_id)
                                  .limit(8)
  end

  def videos_with_same_channel
    @videos_with_same_channel = Video.where(channel_id: @video.channel_id)
                                  .where(hidden: false)
                                  .where.not(youtube_id: @video.youtube_id)
                                  .limit(8)
  end

  def current_search
    @current_search = params[:query]
  end

  def page
    @page ||= params.permit(:page).fetch(:page, 1).to_i
  end

  def video_params
    params
      .require(:video)
      .permit(:leader_id,
              :follower_id,
              :song_id,
              :event_id,
              :hidden,
              :id)
  end

  def filtering_params
    params.permit(
      :leader,
      :follower,
      :channel,
      :genre,
      :orchestra,
      :song_id,
      :query,
      :hd,
      :event_id,
      :year,
      :watched
    )
  end

  def sorting_params
    params.permit(:direction, :sort)
  end

  def show_params
    params.permit(:v)
  end

  def fetch_new_video
    ImportVideoWorker.perform_async(@video.youtube_id)
  end
end
