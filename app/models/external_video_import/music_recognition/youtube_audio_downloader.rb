# frozen_string_literal: true

module ExternalVideoImport
  module MusicRecognition
    class YoutubeAudioDownloader
      YT_DLP_COMMAND_PREFIX = "https://www.youtube.com/watch?v="

      def download_file(slug)
        Tempfile.create([slug.to_s, ".mp3"]) do |file|
          audio_success = system(yt_dlp_command(file, slug, format: "-f bestaudio"))
          if audio_success
            yield file if block_given? && audio_success
          else
            Tempfile.create([slug.to_s, ".mp4"]) do |file|
              system(yt_dlp_command(file, slug))
              yield file if block_given?
            end
          end
        end
      end

      private

      def yt_dlp_command(file, slug, format: "")
        "#{ENV["YT_DLP_BIN"]} '#{YT_DLP_COMMAND_PREFIX + slug}' #{format} --force-overwrites -o '#{file.path}'"
      end
    end
  end
end
