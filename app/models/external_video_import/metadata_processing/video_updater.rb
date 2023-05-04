# frozen_string_literal: true

module ExternalVideoImport
  class VideoUpdateError < StandardError; end

  module MetadataProcessing
    class VideoUpdater
      def initialize(video, thumbnail_attacher: ThumbnailAttacher.new)
        @video = video
        @thumbnail_attacher = thumbnail_attacher
      end

      def update(metadata, timeout: 2.minutes)
        @video.update!(metadata:)
        attach_thumbnail(metadata.youtube.thumbnail_url.highest_resolution)
        @video
      rescue ActiveRecord::RecordInvalid => e
        log_error("Error updating video: #{e.message}")
        raise ExternalVideoImport::VideoUpdateError, e.message
      end

      private

      def attach_thumbnail(url)
        @thumbnail_attacher.attach_thumbnail(@video, url)
      end

      def log_error(message)
        Rails.logger.error(message)
      end
    end
  end
end
