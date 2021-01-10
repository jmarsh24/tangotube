class VideosController < ApplicationController
  # before_action :authenticate_user!

  NUMBER_OF_VIDEOS_PER_PAGE = 10

  helper_method :sort_column, :sort_direction

  def index
    @videos = Video.where.not('leader_id IS NULL AND
                               follower_id IS NULL AND
                               song_id IS NULL OR
                               hidden IS true')
                   .includes(:leader, :follower, :channel, :song)
                   .order(sort_column + ' ' + sort_direction)
                   .filter_videos(params.slice(:leader, :follower, :channel, :genre, :query))

    @current_search = params[:query]

    @videos_paginated = @videos.paginate(page, NUMBER_OF_VIDEOS_PER_PAGE)

    @leader_name   = params[:query].present? ? 'leaders_videos.name'   : 'leaders.name'
    @follower_name = params[:query].present? ? 'followers_videos.name' : 'followers.name'
    @channel_title = params[:query].present? ? 'channels_videos.title' : 'channels.title'
    @songs_genre   = params[:query].present? ? 'songs_videos.genre'    : 'songs.genre'
    @songs_artist  = params[:query].present? ? 'songs_videos.artist'   : 'songs.artist'
    @songs_title   = params[:query].present? ? 'songs_videos.title'    : 'songs.title'

    @leaders    = @videos.joins(:leader).pluck(@leader_name).uniq.sort.map(&:titleize)
    @followers  = @videos.joins(:follower).pluck(@follower_name).uniq.sort.map(&:titleize)
    @channels   = @videos.joins(:channel).pluck(@channel_title).uniq.compact.sort
    @genres     = @videos.joins(:song).pluck(@songs_genre).uniq.compact.sort.map(&:titleize)

    @leader_count   = @leaders.size
    @follower_count = @followers.size
    @channel_count  = @channels.size
    @genre_count    = @genres.size
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
                       'view_count',
                       'leaders_videos.name',
                       'followers_videos.name',
                       'channels_videos.title',
                       'songs_videos.genre']

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
