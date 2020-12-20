class VideosController < ApplicationController
  # before_action :authenticate_user!

  NUMBER_OF_VIDEOS_PER_PAGE = 10

  helper_method :sort_column, :sort_direction

  def index
    @videos = Video.search(params[:q])
                   .includes(:song, :leader, :follower, :channel)
                   .references(:song, :leader, :follower, :channel)

    @videos_sorted = @videos.order(sort_column + ' ' + sort_direction)
    # .where.not(leader_id: [nil, false],
    #            follower_id: [nil, false],
    #            spotify_track_name: [nil, false])

    @videos_filtered = @videos_sorted

    filtering_params(params).each do |key, value|
      @videos_filtered = @videos_sorted.public_send(key, value.downcase) if value.present?
    end

    @videos_paginated = @videos_filtered.paginate(page, NUMBER_OF_VIDEOS_PER_PAGE)

    # Populate Total Number of Options
    @leaders_total_count = @videos.pluck(:"leaders.name").compact.uniq.count
    @followers_total_count = @videos.pluck(:"followers.name").compact.uniq.count
    @channels_total_count = @videos.pluck(:"channels.title").compact.uniq.count
    @genres_total_count = @videos.pluck(:"songs.genre").compact.uniq.count

    # Populate Filters
    @leaders = @videos_filtered.pluck(:"leaders.name").compact.uniq.sort
    @followers = @videos_filtered.pluck(:"followers.name").compact.uniq.sort
    @channels = @videos_filtered.pluck(:"channels.title").compact.uniq.sort
    @genres = @videos_filtered.pluck(:"songs.genre").compact.uniq.map(&:capitalize).sort
  end

  private

  def sort_column
    acceptable_cols = ['songs.title',
                       'songs.artist',
                       'songs.genre',
                       'leaders.name',
                       'followers.name',
                       'channel',
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
    params.slice(:genre, :leader, :follower, :channel)
  end
end
