# frozen_string_literal: true

class Search::EventsController < ApplicationController
  # @route GET /search/events (search_events)
  def index
    @events = Rails.cache.fetch(["search_events", params[:query].presence], expires_in: 1.hour) do
      if params[:query].present?
        Event.search(params[:query])
          .with_attached_profile_image
          .limit(10)
      else
        Event.all.limit(10).order(videos_count: :desc)
      end
    end
  end
end
