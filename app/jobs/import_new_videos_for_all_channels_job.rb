# frozen_string_literal: true

class ImportNewVideosForAllChannelsJob < ApplicationJob
  queue_as :default

  def perform
    Channel.active.find_each(&:import_new_videos(use_scraper: false, use_music_recognizer: false))
  end
end
