namespace :fetch_videos do
  desc "Enqueue a VideoFetcherJob for every Channel"
  task enqueue_for_all_channels: :environment do
    Channel.find_each do |channel|
      ChannelVideoFetcherJob.perform_later(channel.channel_id)
    end
  end
end
