# frozen_string_literal: true

class UpdateAllUploadDatesJob < ApplicationJob
  queue_as :low_priority

  def perform(youtube_id)
    video = Video.find_by(youtube_id:)
    yt_video = Yt::Video.new id: video.youtube_id
  rescue Yt::Errors::NoItems => e
    if e.present?
      video.destroy
    else
      video.upload_date = yt_video.published_at
      video.save
    end
  end
end
