# frozen_string_literal: true

class DestroyAllChannelVideosJob < ApplicationJob
  queue_as :low_priority

  def perform(channel_id)
    Channel.find_by(channel_id:).destroy_all_videos
  end
end
