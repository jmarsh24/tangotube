# frozen_string_literal: true

namespace :subscription do
  desc "Create subscriptions for all channels"
  task to_all_channels: :environment do
    Channel.all.find_each do |channel|
      Subscription.to_youtube_channel(channel.channel_id)
    end
  end
end
