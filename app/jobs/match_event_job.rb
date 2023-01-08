# frozen_string_literal: true

class MatchEventJob < ApplicationJob
  queue_as :low_priority
  sidekiq_options queue: :high, retry: 1

  def perform(event_id)
    Event.find(event_id).match_videos
  end
end
