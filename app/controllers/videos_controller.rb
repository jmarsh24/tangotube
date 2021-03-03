class VideosController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :set_video, only: %i[show edit]
  NUMBER_OF_VIDEOS_PER_PAGE = 120

  helper_method :sort_column, :sort_direction

  def index
    @videos_total = Video.filter_by_not_hidden.size
    @videos = Video.filter_by_not_hidden
                   .includes(:leader, :follower, :channel, :song, :event)
                   .order("#{sort_column} #{sort_direction}")
                   .filter_videos(filtering_params)

    @videos_paginated = @videos.paginate(page_params, NUMBER_OF_VIDEOS_PER_PAGE)
    @videos_paginated = @videos_paginated.shuffle if filtering_params.blank?

    @next_page_items = @videos.paginate(page_params + 1, NUMBER_OF_VIDEOS_PER_PAGE)
    @items_display_count = (@videos.size - (@videos.size - (page_params * NUMBER_OF_VIDEOS_PER_PAGE).clamp(0, @videos.size)))

    @leaders    = @videos.joins(:leader).pluck("leaders.name").uniq.sort.map(&:titleize)
    @followers  = @videos.joins(:follower).pluck("followers.name").uniq.sort.map(&:titleize)
    @channels   = @videos.joins(:channel).pluck("channels.title").uniq.compact.sort
    @artists    = @videos.joins(:song).pluck("songs.artist").uniq.compact.sort.map(&:titleize)
    @genres     = @videos.joins(:song).pluck("songs.genre").uniq.compact.sort.map(&:titleize).uniq

    respond_to do |format|
      format.html
      format.json do
        render json: { videos:   render_to_string(partial: "videos/index/videos", formats: [:html]),
                       loadmore: render_to_string(partial: "videos/index/load_more", formats: [:html]) }
      end
    end
  end

  def show
    @videos_total = Video.filter_by_not_hidden.size
    videos = if Video.where(song_id: @video.song_id).size > 3
               Video.where(song_id: @video.song_id)
             else
               Video.where(channel_id: @video.channel_id)
             end

    @recommended_videos = videos.where(hidden: false)
                                .where.not(youtube_id: @video.youtube_id)
                                .order("popularity DESC")
                                .limit(3)
    @video.clicked!
  end

  def edit
    @video = Video.find_by(id: params[:id])
  end

  def update
    @video = Video.find_by(id: params[:id])
    @video.update(video_params)
    redirect_to watch_path(v: @video.youtube_id)
  end

  private

  def current_search
    @current_search = params[:query]
  end

  def set_video
    @video = Video.find_by(youtube_id: params[:v])
  end

  def sort_column
    acceptable_cols = ["songs.title",
                       "songs.artist",
                       "songs.genre",
                       "leaders.name",
                       "followers.name",
                       "channels.title",
                       "videos.upload_date",
                       "videos.view_count",
                       "songs.last_name_search",
                       "videos.popularity"]

    acceptable_cols.include?(params[:sort]) ? params[:sort] : "videos.popularity"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def page_params
    @page ||= params.permit(:page).fetch(:page, 1).to_i
  end

  def video_params
    params.require(:video).permit(:leader_id, :follower_id, :song_id, :event_id, :hidden)
  end

  def filtering_params
    params.permit(:leader, :follower, :channel, :genre, :orchestra, :song_id, :query, :hd, :event_id)
  end
end
