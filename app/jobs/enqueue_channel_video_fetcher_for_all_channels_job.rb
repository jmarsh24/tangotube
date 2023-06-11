class EnqueueChannelVideoFetcherForAllChannelsJob < ApplicationJob
  queue_as :default

  def perform
    # Enqueue a ChannelVideoFetcherJob for every Channel
    Channel.find_each do |channel|
      ChannelVideoFetcherJob.perform_later(channel.channel_id)
    end
  end
end
