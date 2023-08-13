# frozen_string_literal: true

class Search::CouplesController < ApplicationController
  # @route GET /search/couples (search_couples)
  def index
    @couples = Rails.cache.fetch(["search_couples", params[:query].presence], expires_in: 1.hour) do
      if params[:query].present?
        Couple.includes(dancer: {profile_image_attachment: :blob}, partner: {profile_image_attachment: :blob})
          .search(params[:query])
          .limit(10)
      else
        Couple.all.limit(10).order(videos_count: :desc)
      end
    end
  end
end
