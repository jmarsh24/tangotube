# frozen_string_literal: true

class ImportNewVideosForAllChannelsJob < ApplicationJob
  queue_as :import

  def perform
    Channel.active.find_each do |channel|
      SyncVideosForChannelJob.perform_later(channel.id, use_scraper: false, use_music_recognizer: true)
    end
  end
end
