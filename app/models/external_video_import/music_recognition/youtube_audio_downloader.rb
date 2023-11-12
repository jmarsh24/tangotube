# frozen_string_literal: true

module ExternalVideoImport
  module MusicRecognition
    class YoutubeAudioDownloader
      YT_DLP_COMMAND_PREFIX = "https://www.youtube.com/watch?v="

      def download_file(slug)
        Dir.mktmpdir do |dir|
          output_template = "#{dir}/#{slug}.%(ext)s"
          success = system(yt_dlp_command(output_template, slug, format: "-f bestaudio"))
          if success
            downloaded_file_path = Dir["#{dir}/#{slug}.*"].first

            File.open(downloaded_file_path) do |file|
              yield file
            end
          end
        end
      rescue => e
        Rails.logger.error "Failed to download file: #{e.message}"
      end

      private

      def yt_dlp_command(output_template, slug, format: "")
        "#{Config.yt_dlp_bin!} '#{YT_DLP_COMMAND_PREFIX + slug}' #{format} --force-overwrites -o '#{output_template}'"
      end
    end
  end
end
