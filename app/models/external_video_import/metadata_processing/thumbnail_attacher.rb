# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class ThumbnailAttacher
      def attach_thumbnail(object, thumbnail_url)
        return if thumbnail_url.blank?

        download_thumbnail(thumbnail_url) do |tempfile|
          object.thumbnail.attach(io: tempfile, filename: "#{object.class.name.downcase}_#{thumbnail_url}.jpg")
        end
      rescue Down::Error => e
        log_warning("Failed to download thumbnail from #{thumbnail_url}: #{e.message}")
      rescue Errno::ENOENT => e
        log_warning("Thumbnail file not found: #{e.message}")
      rescue => e
        log_error("Error attaching thumbnail: #{e.message}")
      end

      private

      def download_thumbnail(thumbnail_url)
        Tempfile.open(["thumbnail", ".jpg"]) do |tempfile|
          Down.download(thumbnail_url, destination: tempfile.path)
          yield tempfile
        end
      end

      def log_warning(message)
        Rails.logger.warn(message)
      end

      def log_error(message)
        Rails.logger.error(message)
      end
    end
  end
end
