class VideosController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :current_search, only: %i[index]
  before_action :set_video, only: %i[update edit]
  before_action :set_recommended_videos, only: %i[edit]

  def index
    @search = Video::Search.for(filtering_params: filtering_params,
                                sorting_params:   sorting_params,
                                page:             page)

    respond_to do |format|
      format.html
      format.json do
        render json: { videos:   render_to_string(partial: "videos/index/videos", formats: [:html]),
                       loadmore: render_to_string(partial: "videos/index/load_more", formats: [:html]) }
      end
    end
  end

  def edit; end

  def show
    @video = Video.find_by(youtube_id: show_params[:v])
    set_recommended_videos
    @video.clicked!
  end

  def update
    @video.update(video_params)
    redirect_to watch_path(v: @video.youtube_id)
  end

  def create
    @video = Video.create(youtube_id: params[:video][:youtube_id])
    fetch_new_video

    redirect_to root_path, notice: "Video Sucessfully Added: The video must be approved before the videos are added"
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end

  def set_recommended_videos
    videos = if Video.where(song_id: @video.song_id).size > 3
               Video.where(song_id: @video.song_id)
             else
               Video.where(channel_id: @video.channel_id)
             end

    @recommended_videos = videos.where(hidden: false)
                                .where.not(youtube_id: @video.youtube_id)
                                .order("popularity DESC")
                                .limit(3)
  end

  def current_search
    @current_search = params[:query]
  end

  def page
    @page ||= params.permit(:page).fetch(:page, 1).to_i
  end

  def video_params
    params.require(:video).permit(:leader_id, :follower_id, :song_id, :event_id, :hidden, :id)
  end

  def filtering_params
    params.permit(:leader_id, :follower_id, :channel_id, :genre, :orchestra, :song_id, :query, :hd, :event_id, :year)
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
