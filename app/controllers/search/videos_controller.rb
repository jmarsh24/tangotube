# frozen_string_literal: true

class Search::VideosController < ApplicationController
  # @route GET /search/videos (search_videos)
  def index
    @videos = Rails.cache.fetch(["search_videos", params[:query].presence], expires_in: 1.hour) do
      if params[:query].present?
        Video.search(params[:query])
          .with_attached_thumbnail
          .limit(12)
      else
        Video.all.limit(10).most_popular
      end
    end
  end
end
