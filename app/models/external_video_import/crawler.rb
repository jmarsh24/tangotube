# frozen_string_literal: true

module ExternalVideoImport
  class Crawler
    Metadata =
      Struct.new(
        :youtube,
        :music,
        keyword_init: true
      )

    def initialize(youtube_scraper: Youtube::Scraper.new, music_recognizer: MusicRecognition::MusicRecognizer.new)
      @youtube_scraper = youtube_scraper
      @music_recognizer = music_recognizer
    end

    def metadata(slug)
      Metadata.new(
        youtube: @youtube_scraper.video_metadata(slug),
        music: @music_recognizer.process_audio_snippet(slug)
      )
    end
  end
end
