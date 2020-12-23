class VideosController < ApplicationController
  # before_action :authenticate_user!

  NUMBER_OF_VIDEOS_PER_PAGE = 10

  helper_method :sort_column, :sort_direction

  def index
    @videos = Video.filter(params.slice( :leader, :follower, :channel, :genre))
                   .includes(:leader, :follower, :channel, :song)
                   .order(sort_column + ' ' + sort_direction)

    @videos_paginated = @videos.paginate(page, NUMBER_OF_VIDEOS_PER_PAGE)

    @leaders    = @videos.pluck(:"leaders.name").compact.uniq.map(&:titleize).sort
    @followers  = @videos.pluck(:"followers.name").compact.uniq.map(&:titleize).sort
    @channels   = @videos.pluck(:"channels.title").compact.uniq.sort
    @genres     = @videos.pluck(:"songs.genre").compact.uniq.map(&:capitalize).sort

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
    params.slice(:genre, :leader, :follower, :channel)
  end
end
