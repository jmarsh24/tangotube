# frozen_string_literal: true

class EventsController < ApplicationController
  # @route GET /Events/top (top_Events)
  def top_events
    @events = Event.most_popular.with_attached_profile_image.limit(12)
  end
end
