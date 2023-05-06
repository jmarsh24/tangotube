# frozen_string_literal: true

module ExternalVideoImport
  class Importer
    def initialize(
      video_crawler: Crawler.new,
      metadata_processor: MetadataProcessing::MetadataProcessor.new
    )
      @video_crawler = video_crawler
      @metadata_processor = metadata_processor
    end

    def import(youtube_slug)
      metadata = fetch_metadata(youtube_slug)
      video_attributes = process_metadata(metadata)

      Video.transaction do
        video = MetadataProcessing::VideoCreator.create_video(video_attributes)
        MetadataProcessing::VideoUpdater.new(video).update(metadata)
        video.update(imported_at: Time.current)
      end

      video
    rescue => e
      handle_error("importing", youtube_slug, e)
    end

    def update(video)
      metadata = fetch_metadata(video.youtube_id)
      video_attributes = process_metadata(metadata)

      Video.transaction do
        video.assign_attributes(video_attributes)
        MetadataProcessing::VideoUpdater.new(video).update(metadata)
      end
    rescue => e
      handle_error("updating", video.youtube_id, e)
    end

    private

    def fetch_metadata(youtube_slug)
      @video_crawler.metadata(slug: youtube_slug)
    end

    def process_metadata(metadata)
      @metadata_processor.process(metadata)
    end

    def handle_error(action, youtube_slug, error)
      Rails.logger.error("Error #{action} video with slug '#{youtube_slug}': #{error.message}")
      Rails.logger.error(error.backtrace.join("\n"))
    end
  end
end
