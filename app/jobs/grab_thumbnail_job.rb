# frozen_string_literal: true

class GrabThumbnailJob < ApplicationJob
  queue_as :low_priority

  def perform(youtube_id)
    Video.find_by(youtube_id: youtube_id).grab_thumbnail
  end
end
