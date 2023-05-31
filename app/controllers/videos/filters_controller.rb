# frozen_string_literal: true

class Videos::FiltersController < ApplicationController

  # @route GET /videos/filters (filters_videos)
  def index
     @search_facets = Video::Search.new(filtering_params:, hidden: false, current_user:).facets
     respond_to do |format|
      format.turbo_stream
      format.html
    end
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
      :query)
  end
end
