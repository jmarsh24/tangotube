# frozen_string_literal: true

class Search::DancersController < ApplicationController
  # @route GET /search/dancers (search_dancers)
  def index
    @dancers =
      if params[:query].present?
        Dancer.search(params[:query])
          .with_attached_profile_image
          .limit(100)
          .load_async
      else
        Dancer.all.with_attached_profile_image.limit(100).order(videos_count: :desc).load_async
      end
  end
end
