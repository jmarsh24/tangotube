# frozen_string_literal: true

class VideoThumbnailJob < ApplicationJob
  queue_as :default

  def perform(video)
    downloaded_image = Down.download(video.metadata.youtube.thumbnail_url.highest_resolution)
    video.thumbnail.attach(io: downloaded_image, filename: File.basename(downloaded_image.path), content_type: downloaded_image.content_type)
  rescue Down::Error => e
    Rails.logger.warn("Failed to download thumbnail from #{thumbnail_url}: #{e.message}")
  rescue Errno::ENOENT => e
    Rails.logger.warn("Failed to download thumbnail from #{thumbnail_url}: #{e.message}")
  rescue => e
    Rails.logger.error("Error attaching thumbnail: #{e.message}")
  end
end
