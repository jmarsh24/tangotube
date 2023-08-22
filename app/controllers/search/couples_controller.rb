# frozen_string_literal: true

class Search::CouplesController < ApplicationController
  # @route GET /search/couples (search_couples)
  def index
    @couples = Rails.cache.fetch(["search_couples", params[:query].presence], expires_in: 1.hour) do
      if params[:query].present?
        Couple.joins(:dancer, :partner).preload(:dancer, :partner, dancer: {profile_image_attachment: :blob}, partner: {profile_image_attachment: :blob})
          .search(params[:query])
          .limit(100)
      else
        Couple.joins(:dancer, :partner).preload(dancer: {profile_image_attachment: :blob}, partner: {profile_image_attachment: :blob}).all.limit(100).order(videos_count: :desc)
      end
    end
  end
end
