class VideosController < ApplicationController
  # before_action :authenticate_user!

  NUMBER_OF_VIDEOS_PER_PAGE = 10

  helper_method :sort_column, :sort_direction

  def index
    @videos = Video.includes(:leader, :follower, :song, :channel)
                   .filter_videos(params.slice(:leader, :follower, :channel, :genre, :query))
                   .where.not('leader_id IS NULL AND follower_id IS NULL AND song_id IS NULL ')
                   .where(hidden: false)
                   .order(sort_column + ' ' + sort_direction)

    @videos_paginated = @videos.paginate(page, NUMBER_OF_VIDEOS_PER_PAGE)

    @leader_count   = Video.pluck(:leader_id).compact.uniq.count
    @follower_count = Video.pluck(:follower_id).compact.uniq.count
    @channel_count  = Video.pluck(:channel_id).compact.uniq.count
    @genre_count    = Video.joins(:song).pluck(:genre).compact.uniq.count

    leader_name   = params[:query].present? ? 'leaders_videos.name'   : 'leaders.name'
    follower_name = params[:query].present? ? 'followers_videos.name' : 'followers.name'
    channel_title = params[:query].present? ? 'channels_videos.title' : 'channels.title'
    songs_genre   = params[:query].present? ? 'songs_videos.genre'    : 'songs.genre'

    @leaders    = @videos.joins(:leader).pluck(leader_name).compact.uniq.sort.map(&:titleize)
    @followers  = @videos.joins(:follower).pluck(follower_name).compact.uniq.sort.map(&:titleize)
    @channels   = @videos.joins(:channel).pluck(channel_title).compact.uniq.sort
    @genres     = @videos.joins(:song).pluck(songs_genre).compact.uniq.sort.map(&:titleize)
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
