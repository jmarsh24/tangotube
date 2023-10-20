# frozen_string_literal: true

class Search::OrchestrasController < ApplicationController
  # @route GET /search/orchestras (search_orchestras)
  def index
    @orchestras = Rails.cache.fetch(["search_orchestras", params[:query].presence], expires_in: 1.hour) do
      if params[:query].present?
        Orchestra.search(params[:query])
          .with_attached_profile_image
          .limit(100)
          .load_async
      else
        Orchestra.all.with_attached_profile_image.limit(100).order(videos_count: :desc).load_async
      end
    end
  end
end
