# frozen_string_literal: true

namespace :cleanup do
  desc "Remove disabled channel videos from database"
  task remove_disabled_channel_videos: :environment do
    Channel.where(active: false).each do |channel|
      channel.destroy_all_videos
    end
  end
end
