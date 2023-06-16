# frozen_string_literal: true

class FacetsController < ApplicationController
  helper_method :filtering_params

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
      :id,
      :dancer,
      :query,
      :watched,
      :liked
    )
  end
end
