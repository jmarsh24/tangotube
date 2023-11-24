# frozen_string_literal: true

class SyncVideosForChannelJob < ApplicationJob
  queue_as :import

  def perform(channel, use_scraper:, use_music_recognizer:)
    return unless channel.active?

    channel.sync_videos(use_scraper:, use_music_recognizer: true)
  end
end
