# frozen_string_literal: true

class GrabThumbnailJob < ApplicationJob
  queue_as :low_priority

  def perform(video)
    video.grab_thumbnail
  end
end
