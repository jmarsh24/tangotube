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
            downloaded_file = Dir["#{dir}/#{slug}.*"].first

            Tempfile.create([slug, File.extname(downloaded_file)]) do |tempfile|
              FileUtils.move(downloaded_file, tempfile.path)
              yield tempfile if block_given?
            end
          end
        end
      rescue => e
        Rails.logger.error "Failed to download file: #{e.message}"
      end

      private

      def yt_dlp_command(output_template, slug, format: "")
        "#{ENV["YT_DLP_BIN"]} '#{YT_DLP_COMMAND_PREFIX + slug}' #{format} --force-overwrites -o '#{output_template}'"
      end
    end
  end
end
