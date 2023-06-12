# frozen_string_literal: true

module ExternalVideoImport
  class Importer
    def initialize(video_crawler: Crawler.new, metadata_processor: MetadataProcessing::MetadataProcessor.new)
      @video_crawler = video_crawler
      @metadata_processor = metadata_processor
    end

    def import(youtube_slug, use_scraper: true, use_music_recognizer: true)
      metadata = fetch_metadata(youtube_slug, use_scraper:, use_music_recognizer:)

      video_attributes = process_metadata(metadata)
      Video.transaction do
        video = Video.create!(video_attributes)
        MetadataProcessing::VideoUpdater.new(video).update(metadata)
        video.update!(metadata_updated_at: Time.current)
        video
      end
    rescue => e
      handle_error("importing", youtube_slug, e)
    end

    def update(video, use_scraper: true, use_music_recognizer: true)
      metadata = fetch_metadata(video.youtube_id, use_scraper:, use_music_recognizer:)
      video_attributes = process_metadata(metadata)
      Video.transaction do
        video.assign_attributes(video_attributes)
        MetadataProcessing::VideoUpdater.new(video).update(metadata)
        video.update!(metadata_updated_at: Time.current)
      end

      video
    rescue => e
      handle_error("updating", video.youtube_id, e)
    end

    private

    def fetch_metadata(slug, use_scraper:, use_music_recognizer:)
      @video_crawler.metadata(slug, use_scraper:, use_music_recognizer:)
    end

    def process_metadata(metadata)
      @metadata_processor.process(metadata)
    end

    def handle_error(action, youtube_slug, error)
      Rails.logger.error("Error #{action} video with slug '#{youtube_slug}': #{error.message}")
      Rails.logger.error(error.backtrace.join("\n"))
      raise error
    end
  end
end
