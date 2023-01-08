# frozen_string_literal: true

class UpdateHdColumnJob < ApplicationJob
  queue_as :low_priority

  def perform(youtube_id)
    Video.update_video_hd(youtube_id)
  end
end
