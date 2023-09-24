# frozen_string_literal: true

class ImportNewVideosForAllChannelsJob < ApplicationJob
  queue_as :default

  def perform(options = {})
    use_scraper = options.fetch(:use_scraper, false)
    use_music_recognizer = options.fetch(:use_music_recognizer, false)
    Channel.active.find_each do |channel|
      channel.sync_videos(use_scraper:, use_music_recognizer:)
    end
  end
end
