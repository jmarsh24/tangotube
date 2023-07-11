# frozen_string_literal: true

class VideoThumbnailJob < ApplicationJob
  queue_as :default

  BASE_THUMBNAIL_URL = "https://i.ytimg.com/vi"
  RESOLUTIONS = ["maxresdefault.jpg", "sddefault.jpg", "hqdefault.jpg", "mqdefault.jpg", "default.jpg"]

  def perform(video)
    return if video.youtube_id.blank?

    RESOLUTIONS.each do |resolution|
      thumbnail_url = "#{BASE_THUMBNAIL_URL}/#{video.youtube_id}/#{resolution}"
      next unless image_exists?(thumbnail_url)

      begin
        downloaded_image = Down.download(thumbnail_url)
        video.thumbnail.attach(io: downloaded_image, filename: File.basename(downloaded_image.path), content_type: downloaded_image.content_type)
        break
      rescue Down::Error => e
        Rails.logger.warn("Failed to download thumbnail from #{thumbnail_url}: #{e.message}")
      rescue Errno::ENOENT => e
        Rails.logger.warn("Failed to download thumbnail from #{thumbnail_url}: #{e.message}")
      rescue => e
        Rails.logger.error("Error attaching thumbnail: #{e.message}")
      end
    end
  end

  private

  def image_exists?(url)
    uri = URI.parse(url)
    request = Net::HTTP.new(uri.host, uri.port)
    request.use_ssl = true if uri.scheme == "https"
    path = uri.path unless uri.path.empty?

    res = request.request_head(path || "/")
    if res.is_a?(Net::HTTPRedirection)
      image_exists?(res["location"]) # Go after redirects
    else
      !["404", "403"].include?(res.code) # Not from 404 and 403, in case those are the HTTP response status codes
    end
  rescue
    false
  end
end
