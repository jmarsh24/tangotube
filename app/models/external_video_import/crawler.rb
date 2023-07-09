# frozen_string_literal: true

module ExternalVideoImport
  class Crawler
    def initialize(metadata_provider: Youtube::MetadataProvider.new, music_recognizer: MusicRecognition::MusicRecognizer.new)
      @metadata_provider = metadata_provider
      @music_recognizer = music_recognizer
    end

    def metadata(slug, use_scraper: false, use_music_recognizer: false)
      Metadata.new(
        youtube: @metadata_provider.video_metadata(slug, use_scraper:),
        music: use_music_recognizer ? @music_recognizer.process_audio_snippet(slug) : MusicRecognition::Metadata.new
      )
    end
  end
end
