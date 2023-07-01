# frozen_string_literal: true

class UpdateVideoMetadataJob < ApplicationJob
  queue_as :default

  def perform
    batch_size = 500

    Video.where(title: nil).find_in_batches(batch_size:).with_index do |videos, batch|
      videos.each do |video|
        update_metadata(video)
      end
      Rails.logger.info "Processed batch ##{batch + 1}"
    end
  end

  private

  def update_metadata(video)
    youtube_data = video.metadata.youtube

    video.update!(
      upload_date_year: DateTime.parse(Video.first.metadata.youtube.upload_date.to_s).year,
      title: youtube_data.title,
      description: youtube_data.description,
      hd: youtube_data.hd,
      youtube_view_count: youtube_data.view_count.to_i,
      youtube_like_count: youtube_data.like_count.to_i,
      youtube_tags: youtube_data.tags,
      duration: youtube_data.duration.to_i,
      acr_response_code: youtube_data.music.code
    )
  rescue => e
    Rails.logger.error "Failed to update metadata for video ID #{video.id}: #{e.message}"
  end
end
