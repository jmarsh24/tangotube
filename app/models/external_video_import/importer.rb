module ExternalVideoImport
  class Importer
    def initialize(
      video_crawler: Crawler.new,
      metadata_processor: MetadataProcessing::MetadataProcessor.new,
      thumbnail_attacher: MetadataProcessing::ThumbnailAttacher.new
    )
      @video_crawler = video_crawler
      @metadata_processor = metadata_processor
      @thumbnail_attacher = thumbnail_attacher
    end

    def import(youtube_slug)
      metadata = @video_crawler.metadata(slug: youtube_slug)

      video_attributes = @metadata_processor.process(metadata)
      Video.transaction do
        video = MetadataProcessing::VideoCreator.create_video(video_attributes)
        video.metadata = metadata
        @thumbnail_attacher.attach_thumbnail(video, metadata.youtube.thumbnail_url.highest_resolution)
        video.save!
        video
      end
    end
  end
end
