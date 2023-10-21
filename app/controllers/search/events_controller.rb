# frozen_string_literal: true

class Search::EventsController < ApplicationController
  # @route GET /search/events (search_events)
  def index
    @events =
      if params[:query].present?
        Event.search(params[:query])
          .with_attached_profile_image
          .limit(100)
          .load_async
      else
        Event.all.with_attached_profile_image.limit(100).order(videos_count: :desc).load_async
      end
  end
end
