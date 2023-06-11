class ChannelVideoFetcherJob < ApplicationJob
  queue_as :default

  def perform(channel_id, use_scraper: true, use_music_recognizer: true)
    fetcher = ChannelVideoFetcher.new(channel_id, use_scraper:, use_music_recognizer:)
    fetcher.fetch_new_videos
  end
end
