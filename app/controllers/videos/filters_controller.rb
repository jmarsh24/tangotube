# frozen_string_literal: true

class Videos::FiltersController < ApplicationController
  
  helper_method :filtering_params
  
  # @route GET /videos/filters (filters_videos)
  def index
    @search_facets = Video::Search.new(filtering_params:, current_user:).facets
  end

  private

  def filtering_params
    params.permit(
      :leader,
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
      :query,
      :watched,
      :liked)
  end
end
