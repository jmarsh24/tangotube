# frozen_string_literal: true

class CallUpdateAllVideosJob < ApplicationJob
  queue_as :low_priority

  def perform
    Video.all.find_each do |video|
      UpdateAllUploadDatesJob.perform_later(video.youtube_id)
    end
  end
end
