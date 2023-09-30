# frozen_string_literal: true

class SyncVideosForChannelJob < ApplicationJob
  queue_as :default

  def perform(channel_id, use_scraper:, use_music_recognizer:)
    channel = Channel.find(channel_id)
    return unless channel.active?

    channel.sync_videos(use_scraper:, use_music_recognizer:)
  end
end
