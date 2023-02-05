# frozen_string_literal: true

class GrabChannelThumbnailJob < ApplicationJob
  queue_as :low_priority

  def perform(video)
    channel.grab_thumbnail
  end
end
