class ChannelVideoFetcherJob < ApplicationJob
  queue_as :default

  def perform(channel_id, use_scraper: true)
    fetcher = ChannelVideoFetcher.new(channel_id, use_scraper:)
    fetcher.fetch_new_videos
  end
end
