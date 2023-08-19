# frozen_string_literal: true

class Search::DancersController < ApplicationController
  # @route GET /search/dancers (search_dancers)
  def index
    @dancers = Rails.cache.fetch(["search_dancers", params[:query].presence], expires_in: 1.hour) do
      if params[:query].present?
        Dancer.search(params[:query])
          .with_attached_profile_image
          .limit(100)
      else
        Dancer.all.limit(100).order(videos_count: :desc)
      end
    end
  end
end
