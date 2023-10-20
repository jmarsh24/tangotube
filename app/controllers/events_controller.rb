# frozen_string_literal: true

class EventsController < ApplicationController
  # @route GET /events/top (top_events)
  def top_events
    @events = Event.most_popular.with_attached_profile_image.limit(12).load_async
  end
end
