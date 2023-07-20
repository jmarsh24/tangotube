# frozen_string_literal: true

class ImportNewVideosForAllChannelsJob < ApplicationJob
  queue_as :default

  def perform(use_scraper: false, use_music_recognizer: false)
    Channel.active.find_each do |channel|
      channel.import_new_videos(use_scraper:, use_music_recognizer:)
    end
  end
end
