class EnqueueChannelVideoFetcherForAllChannelsJob < ApplicationJob
  queue_as :default

  def perform(use_scraper: true)
    Channel.find_each do |channel|
      ChannelVideoFetcherJob.perform_later(channel.channel_id, use_scraper:)
    end
  end
end
