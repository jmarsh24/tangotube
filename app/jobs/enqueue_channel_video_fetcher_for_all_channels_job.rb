# frozen_string_literal: true

class EnqueueChannelVideoFetcherForAllChannelsJob < ApplicationJob
  queue_as :default

  def perform(use_scraper: true, use_music_recognizer: true)
    Channel.find_each do |channel|
      ChannelVideoFetcherJob.perform_later(channel.channel_id, use_scraper:, use_music_recognizer:)
    end
  end
end
