class VideosController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :set_video, only: %i[show edit]

  NUMBER_OF_VIDEOS_PER_PAGE = 120

  helper_method :sort_column, :sort_direction

  def index
    @videos_total = Video.all.where(hidden: false).size
    @videos = Video.where(hidden: false)
                   .includes(:leader, :follower, :channel, :song, :event)
                   .order(sort_column + ' ' + sort_direction)
                   .filter_videos(filtering_params)

    @videos_paginated = @videos.paginate(page, NUMBER_OF_VIDEOS_PER_PAGE)
    @videos_paginated = @videos_paginated.shuffle if filtering_params.blank?

    @current_search = params[:query]
    @videos_paginated_size = @videos_paginated.size * (@page + 1)

    @leaders    = @videos.joins(:leader).pluck('leaders.name').uniq.sort.map(&:titleize)
    @followers  = @videos.joins(:follower).pluck('followers.name').uniq.sort.map(&:titleize)
    @channels   = @videos.joins(:channel).pluck('channels.title').uniq.compact.sort
    @artists    = @videos.joins(:song).pluck('songs.artist').uniq.compact.sort.map(&:titleize)
    @genres     = @videos.joins(:song).pluck('songs.genre').uniq.compact.sort.map(&:titleize).uniq
  end

  def show
    @videos_total = Video.all.where(hidden: false).size
    videos = if Video.where(song_id: @video.song_id).size > 3
               Video.where(song_id: @video.song_id)
             else
               Video.where(channel_id: @video.channel_id)
             end

    @recommended_videos = videos.where(hidden: false)
                                .where.not(youtube_id: @video.youtube_id)
                                .order('popularity DESC')
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

  def set_video
    @video = Video.find_by(youtube_id: params[:v])
  end

  def sort_column
    acceptable_cols = ['songs.title',
                       'songs.artist',
                       'songs.genre',
                       'leaders.name',
                       'followers.name',
                       'channels.title',
                       'videos.upload_date',
                       'videos.view_count',
                       'songs.last_name_search',
                       'videos.popularity']

    acceptable_cols.include?(params[:sort]) ? params[:sort] : 'videos.popularity'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def page
    @page ||= params.permit(:page).fetch(:page, 0).to_i
  end

  def video_params
    params.require(:video).permit(:leader_id, :follower_id, :song_id, :event_id, :hidden)
  end

  def filtering_params
    params.permit(:leader, :follower, :channel, :genre, :orchestra, :song_id, :query, :hd, :event_id)
  end
end
