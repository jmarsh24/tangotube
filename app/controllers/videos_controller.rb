class VideosController < ApplicationController
  # before_action :authenticate_user!

  NUMBER_OF_VIDEOS_PER_PAGE = 10
  HERO_YOUTUBE_ID = 's6iptZdCcG0'.freeze

  helper_method :sort_column, :sort_direction

  def index
    @videos = Video.search(params[:q])
                   .includes(:song, :leader, :follower, :videotype, :event)
                   .references(:song, :leader, :follower, :videotype, :event)

    @videos_sorted = @videos.order(sort_column + ' ' + sort_direction)
                            .where.not(leader_id: [nil, false], follower_id: [nil, false], spotify_track_name: [nil, false])

    @videos_filtered = @videos_sorted

    filtering_params(params).each do |key, value|
      @videos_filtered = @videos_filtered.public_send(key, value) if value.present?
    end

    @videos_paginated = @videos_filtered.paginate(page, NUMBER_OF_VIDEOS_PER_PAGE)

    first_youtube_id ||= if @videos_filtered.empty?
                           HERO_YOUTUBE_ID
                         else
                           @videos_filtered.first.youtube_id
                         end

    @active_youtube_id ||= params[:youtube_id] || first_youtube_id

    @active_video = Video.find_by(youtube_id: @active_youtube_id)

    # Populate Total Number of Options
    @videotypes_total_count = @videos.pluck(:"videotypes.name").compact.uniq.sort.count
    @leaders_total_count = @videos.pluck(:"leaders.name").compact.uniq.sort.count
    @followers_total_count = @videos.pluck(:"followers.name").compact.uniq.sort.count
    @events_total_count = @videos.pluck(:"events.name").compact.uniq.sort.count
    @channels_total_count = @videos.pluck(:channel).compact.uniq.sort.count
    @genres_total_count = @videos.pluck(:"songs.genre").compact.uniq.sort.count

    # Populate Filters
    @videotypes = @videos_filtered.pluck(:"videotypes.name").compact.uniq.sort
    @leaders = @videos_filtered.pluck(:"leaders.name").compact.uniq.sort
    @followers = @videos_filtered.pluck(:"followers.name").compact.uniq.sort
    @events = @videos_filtered.pluck(:"events.name").compact.uniq.sort
    @channels = @videos_filtered.pluck(:channel).compact.uniq.sort
    @genres = @videos_filtered.pluck(:"songs.genre").compact.uniq.sort
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
                       'view_count',
                       'videotypes.name',
                       'events.name']

    acceptable_cols.include?(params[:sort]) ? params[:sort] : 'upload_date'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def page
    @page ||= params.permit(:page).fetch(:page, 0).to_i
  end

  def filtering_params(params)
    params.slice(:genre, :videotype, :leader, :follower, :event, :channel)
  end
end
