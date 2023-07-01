# frozen_string_literal: true

module ExternalVideoImport
  class Importer
    def initialize(video_crawler: Crawler.new, metadata_processor: MetadataProcessing::MetadataProcessor.new)
      @video_crawler = video_crawler
      @metadata_processor = metadata_processor
    end

    def import(youtube_id, use_scraper: false, use_music_recognizer: false)
      return if Video.exists?(youtube_id:)

      metadata = @video_crawler.metadata(youtube_id, use_scraper:, use_music_recognizer:)

      video_attributes = @metadata_processor.process(metadata)

      Video.transaction do
        video = Video.create!(video_attributes)
        MetadataProcessing::VideoUpdater.new(video).update(metadata)
        video.update!(metadata_updated_at: Time.current)
        video
      end
    rescue => e
      handle_error("importing", youtube_id, e)
    end

    def update(video, use_scraper: false, use_music_recognizer: false)
      use_music_recognizer &&= video.acr_response_code != 0
      metadata = @video_crawler.metadata(video.youtube_id, use_scraper:, use_music_recognizer:)

      # Preserve existing metadata values if not using scraper
      if !use_scraper
        metadata.youtube.song = video.metadata.youtube.song.attributes
        metadata.youtube.recommended_video_ids = video.metadata.youtube.recommended_video_ids
      end

      # Preserve existing metadata.music values if not using music recognizer
      if !use_music_recognizer && (metadata.music.code != 0 || metadata.music.code != 1001)
        metadata.music = video.metadata.music.attributes
      end

      video_attributes = @metadata_processor.process(metadata)

      Video.transaction do
        video.update!(video_attributes)
        MetadataProcessing::VideoUpdater.new(video).update(metadata)
        video.update!(metadata_updated_at: Time.current)
        video
      end
    rescue => e
      handle_error("updating", video.youtube_id, e)
    end

    private

    def handle_error(action, youtube_slug, error)
      case error
      when Yt::Errors::NoItems
        Rails.logger.warn("No items returned from YouTube API while #{action} video with slug '#{youtube_slug}': #{error.message}")
        nil
      else
        Rails.logger.error("Error #{action} video with slug '#{youtube_slug}': #{error.message}")
        Rails.logger.error(error.backtrace.join("\n"))
        raise error
      end
    end
  end
end
