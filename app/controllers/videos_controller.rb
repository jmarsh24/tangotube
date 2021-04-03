class VideosController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :current_search, only: %i[index]
  before_action :set_video, only: %i[update edit]
  before_action :set_recommended_videos, only: %i[edit]

  NUMBER_OF_VIDEOS_PER_PAGE = 60

  helper_method :sort_column, :sort_direction

  def index
    @videos = Video.not_hidden
                   .includes(:leader, :follower, :channel, :song, :event)
                   .order("#{sort_column} #{sort_direction}")
                   .filter_videos(filtering_params)

    @videos_paginated = @videos.paginate(page, NUMBER_OF_VIDEOS_PER_PAGE)
    @videos_paginated = @videos_paginated.shuffle if filtering_params.blank?

    @next_page_items = @videos.paginate(page + 1, NUMBER_OF_VIDEOS_PER_PAGE)
    @items_display_count = (@videos.size - (@videos.size - (page * NUMBER_OF_VIDEOS_PER_PAGE).clamp(0, @videos.size)))

    @leaders = facet_id("leaders.name", "leaders.id", :leader)
    @followers = facet_id("followers.name", "followers.id", :follower)
    @channels = facet_id("channels.title", "channels.id", :channel)
    @artists = facet("songs.artist", :song)
    @genres = facet("songs.genre", :song)
    @years = facet_on_year("upload_date")
  end

  def edit
  end

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

  def facet_on_year(table_column)
    query = "extract(year from #{table_column})::int AS facet_value, count(#{table_column}) AS occurrences"
    counts = Video.filter_videos(filtering_params).select(query).group("facet_value").order("facet_value DESC")
    counts.map do |c|
      ["#{c.facet_value} (#{c.occurrences})", c.facet_value]
    end
  end

  def facet(table_column, model)
    query = "#{table_column} AS facet_value, count(#{table_column}) AS occurrences"
    counts = Video.filter_videos(filtering_params).joins(model).select(query).group(table_column).order("occurrences DESC")
    counts.map do |c|
      ["#{c.facet_value.titleize} (#{c.occurrences})", c.facet_value.downcase]
    end
  end

  def facet_id(table_column, table_column_id, model)
    query = "#{table_column} AS facet_value, count(#{table_column}) AS occurrences, #{table_column_id} AS facet_id_value"
    counts = Video.filter_videos(filtering_params).joins(model).select(query).group(table_column, table_column_id).order("occurrences DESC")
    counts.map do |c|
      ["#{c.facet_value.titleize} (#{c.occurrences})", c.facet_id_value]
    end
  end

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

  def page
    @page ||= params.permit(:page).fetch(:page, 1).to_i
  end

  def video_params
    params.require(:video).permit(:leader_id, :follower_id, :song_id, :event_id, :hidden, :id)
  end

  def filtering_params
    params.permit(:leader_id, :follower_id, :channel_id, :genre, :orchestra, :song_id, :query, :hd, :event_id, :year)
  end

  def show_params
    params.permit(:v)
  end

  def fetch_new_video
    ImportVideoWorker.perform_async(@video.youtube_id)
  end

  def fetch_new_video
    ImportVideoWorker.perform_async(@video.youtube_id)
  end
end
