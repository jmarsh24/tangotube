# frozen_string_literal: true

module Import
  class Crawler
    def initialize(
      metadata_provider: Youtube::MetadataProvider.new,
      music_recognizer: MusicRecognition::MusicRecognizer.new,
      title_description_extractor: TitleDescriptionExtractor::Extractor.new
    )
      @metadata_provider = metadata_provider
      @music_recognizer = music_recognizer
      @title_description_extractor = title_description_extractor
    end

    def metadata(slug, use_scraper: false, use_music_recognizer: false, use_chat_gpt: false)
      youtube = @metadata_provider.video_metadata(slug, use_scraper:)
      Metadata.new(
        youtube:,
        music:
          if use_music_recognizer
            @music_recognizer.process_audio_snippet(slug)
          else
            MusicRecognition::Metadata.new
          end,
        chat_gpt:
          if use_chat_gpt
            @title_description_extractor.extract_metadata(
              video_title: youtube.title,
              video_description: youtube.description
            )
          else
            TitleDescriptionExtractor::Metadata.new
          end
      )
    end
  end
end
