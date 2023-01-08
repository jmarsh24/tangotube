# frozen_string_literal: true

class YoutubeEventHandlerJob < ApplicationJob
  queue_as :low_priority

  def perform(event_id)
    YoutubeEvent.find(event_id).handle_event
  end
end
