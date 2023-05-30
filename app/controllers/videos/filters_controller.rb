# frozen_string_literal: true

class Videos::FiltersController < ApplicationController
  before_action :videos_search

  # @route GET /videos/filters (filters_videos)
  def filters
    genres
    leaders
    followers
    orchestras
    years
  end

  private

  def videos_search
    @videos_search = Video::Search.new(filtering_params:, hidden: false, current_user:)
  end

  def genres
    @genres = @videos_search.genres
  end

  def leaders
    @leaders = @videos_search.leaders
  end

  def followers
    @followers = @videos_search.followers
  end

  def orchestras
    @orchestras = @videos_search.orchestras
  end

  def years
    @years = @videos_search.years
  end

  def filtering_params
    params.permit(:leader,
      :follower,
      :channel,
      :genre,
      :orchestra,
      :song,
      :hd,
      :event,
      :year,
      :id,
      :dancer,
      :query)
  end
end
