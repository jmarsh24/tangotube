# frozen_string_literal: true

module ExternalVideoImport
  module VideoCrawl
    class VideoCrawler
      def initialize(youtube_scraper: ExternalVideoImport::VideoCrawl::Youtube::YoutubeScraper.new, music_recognizer: ExternalVideoImport::VideoCrawl::MusicRecognition::MusicRecognizer.new)
        @youtube_scraper = youtube_scraper
        @music_recognizer = music_recognizer
      end

      def video_metadata(slug)
        VideoMetadata.new(
          youtube: @youtube_scraper.video_metadata(slug),
          acr_cloud: @music_recognizer.process_audio_snippet(slug)
        )
      end
    end
  end
end
