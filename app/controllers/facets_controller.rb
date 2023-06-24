# frozen_string_literal: true

class FacetsController < ApplicationController
  helper_method :filtering_params

  # @route GET /facets/:id (facet)
  def show
    @facet = Video::Search.new(filtering_params:, user: current_user).facet(name: params[:id])
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
      :dancer,
      :query,
      :watched,
      :liked
    )
  end
end
