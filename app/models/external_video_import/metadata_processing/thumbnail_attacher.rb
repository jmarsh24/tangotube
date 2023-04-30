module ExternalVideoImport
  module MetadataProcessing
    class ThumbnailAttacher
      def self.attach_thumbnail(video, thumbnail_url)
        return if thumbnail_url.blank?

        Tempfile.open(["thumbnail", ".jpg"]) do |tempfile|
          Down.download(thumbnail_url, destination: tempfile.path)
          video.thumbnail.attach(io: tempfile, filename: "#{video.youtube_id}.jpg")
        end
      rescue Down::Error => e
        Rails.logger.warn("Failed to download thumbnail from #{thumbnail_url}: #{e.message}")
      rescue Errno::ENOENT => e
        Rails.logger.warn("Thumbnail file not found: #{e.message}")
      rescue => e
        Rails.logger.error("Error attaching thumbnail: #{e.message}")
      end
    end
  end
end
