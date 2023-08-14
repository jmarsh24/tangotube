# frozen_string_literal: true

class DestroyAllChannelVideosJob < ApplicationJob
  queue_as :low_priority

  def perform(youtube_slug)
    Channel.find_by(youtube_slug:).destroy_all_videos
  end
end
