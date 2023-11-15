class ThumbnailAttacher
  def attach_thumbnail(object, thumbnail_url)
    return if thumbnail_url.blank?
    downloaded_image = Down.download(thumbnail_url)
    object.thumbnail.attach(io: downloaded_image, filename: File.basename(downloaded_image.path), content_type: downloaded_image.content_type)
  rescue Down::Error => e
    Rails.logger.warn("Failed to download thumbnail from #{thumbnail_url}: #{e.message}")
  rescue Errno::ENOENT => e
    Rails.logger.warn("Failed to download thumbnail from #{thumbnail_url}: #{e.message}")
  rescue => e
    Rails.logger.error("Error attaching thumbnail: #{e.message}")
  end
end
