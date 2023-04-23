# frozen_string_literal: true

module ExternalVideoImport
  module VideoCrawl
    module MusicRecognition
      class MusicRecognizer
        def initialize(acr_cloud: AcrCloud.new, audio_trimmer: AudioTrimmer.new, youtube_audio_downloader: YoutubeAudioDownloader.new)
          @acr_cloud = acr_cloud
          @audio_trimmer = audio_trimmer
          @youtube_audio_downloader = youtube_audio_downloader
        end

        def process_audio_snippet(slug)
          music_recognition_metadata = nil
          @youtube_audio_downloader.download_file(slug) do |full_length_audio_file|
            @audio_trimmer.trim(full_length_audio_file) do |trimmed_audio_file|
              music_recognition_metadata = @acr_cloud.analyze(file: trimmed_audio_file)
            end
          end
          music_recognition_metadata
        end
      end
    end
  end
end
