# frozen_string_literal: true

module ExternalVideoImport
  class Crawler
    def initialize(metadata_provider: Youtube::MetadataProvider.new, music_recognizer: MusicRecognition::MusicRecognizer.new)
      @metadata_provider = metadata_provider
      @music_recognizer = music_recognizer
    end

    def metadata(slug, use_scraper: true)
      binding.pry
      Metadata.new(
        youtube: @metadata_provider.video_metadata(slug, use_scraper:),
        music: @music_recognizer.process_audio_snippet(slug)
      )
    end
  end
end
