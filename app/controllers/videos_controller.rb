class VideosController < ApplicationController
  # before_action :authenticate_user!

  NUMBER_OF_VIDEOS_PER_PAGE = 60

  helper_method :sort_column, :sort_direction

  def index
    @videos_total = Video.all.size
    @videos = Video.where.not('hidden IS true')
                   .includes(:leader, :follower, :channel, :song, :event)
                   .order(sort_column + ' ' + sort_direction)
                   .filter_videos(params.slice(:leader, :follower, :channel, :genre, :orchestra, :song_id, :query,
                                               :hd, :event_id))
    @videos_paginated = @videos.paginate(page, NUMBER_OF_VIDEOS_PER_PAGE)
    if filtering_params(params).empty?
      @videos_paginated = @videos.paginate(page, NUMBER_OF_VIDEOS_PER_PAGE)
      @videos_paginated = @videos_paginated.shuffle if filtering_params(params).present?
    end

    @current_search = params[:query]
    @videos_paginated_size = @videos_paginated.size * (@page + 1)

    @leaders    = @videos.joins(:leader).pluck('leaders.name').uniq.sort.map(&:titleize)
    @followers  = @videos.joins(:follower).pluck('followers.name').uniq.sort.map(&:titleize)
    @channels   = @videos.joins(:channel).pluck('channels.title').uniq.compact.sort
    @artists    = @videos.joins(:song).pluck('songs.artist').uniq.compact.sort.map(&:titleize)
    @genres     = @videos.joins(:song).pluck('songs.genre').uniq.compact.sort.map(&:titleize)
  end

  def show
    @videos_total = Video.all.size
    @video = Video.find_by(youtube_id: params[:v])
    song_id = @video.song_id
    @videos = Video.where(song_id: song_id).where.not(id: @video.id).order('popularity DESC').limit(5)
    @video.clicked!
  end

  def edit
    @video = Video.find_by(id: params[:id])
  end

  def update
    @video = Video.find(params[:id])
    @video.update(video_params)
    flash[:notice] = 'Updated Video Successfully'
    redirect_to root_path
  end

  private

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

  def filtering_params(params)
    params.permit.slice(:leader, :follower, :channel, :genre, :orchestra, :song_id, :query, :hd, :event_id)
  end
end
