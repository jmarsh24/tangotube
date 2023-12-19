# frozen_string_literal: true

class SyncVideosForChannelJob < ApplicationJob
  queue_as :import

  def perform(channel)
    return unless channel.active?

    channel.sync_videos
  end
end
