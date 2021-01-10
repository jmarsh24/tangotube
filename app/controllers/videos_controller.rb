class VideosController < ApplicationController
  # before_action :authenticate_user!

  NUMBER_OF_VIDEOS_PER_PAGE = 10

  helper_method :sort_column, :sort_direction

  def index
    @videos = Video.includes(:leader, :follower, :song, :channel)
                   .where.not('leader_id IS NULL AND follower_id IS NULL AND song_id IS NULL')
                   .where(hidden: false)
                   .filter_videos(params.slice(:leader, :follower, :channel, :genre, :query))
                   .order(sort_column + ' ' + sort_direction)

    @videos_paginated = @videos.paginate(page, NUMBER_OF_VIDEOS_PER_PAGE)

    leader_name   = params[:query].present? ? 'leaders_videos.name'   : 'leaders.name'
    follower_name = params[:query].present? ? 'followers_videos.name' : 'followers.name'
    channel_title = params[:query].present? ? 'channels_videos.title' : 'channels.title'
    songs_genre   = params[:query].present? ? 'songs_videos.genre'    : 'songs.genre'

    @leaders    = Leader.joins(:videos).pluck(:name).sort.map(&:titleize)
    @followers  = Follower.joins(:videos).pluck(:name).sort.map(&:titleize)
    @channels   = Channel.joins(:videos).pluck(:title).sort
    @genres     = Song.joins(:videos).pluck(:genre).sort.map(&:titleize)

    @leader_count   = @leaders.count
    @follower_count = @followers.count
    @channel_count  = @channels.count
    @genre_count    = @genres.count
  end

  private

  def sort_column
    acceptable_cols = ['songs.title',
                       'songs.artist',
                       'songs.genre',
                       'leaders.name',
                       'followers.name',
                       'channels.title',
                       'upload_date',
                       'view_count']

    acceptable_cols.include?(params[:sort]) ? params[:sort] : 'upload_date'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def page
    @page ||= params.permit(:page).fetch(:page, 0).to_i
  end

  def filtering_params(params)
    params.slice(:genre, :leader, :follower, :channel, :query)
  end
end
