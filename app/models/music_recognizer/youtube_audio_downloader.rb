# frozen_string_literal: true

class MusicRecognizer::YoutubeAudioDownloader
  YT_DLP_COMMAND_PREFIX = "https://www.youtube.com/watch?v="
  YT_DLP_COMMAND_DOWNLOAD_AUDIO = "-f 140 --force-overwrites -o "

  def download_file(slug:)
    Tempfile.create([slug.to_s, ".mp3"]) do |file|
      system(yt_dlp_command(file, slug))
      yield file
    end
  end

  private

  def yt_dlp_command(file, slug)
    "#{ENV["YT_DLP_BIN"]} '#{YT_DLP_COMMAND_PREFIX + slug}' #{YT_DLP_COMMAND_DOWNLOAD_AUDIO} #{file.path}"
  end
end
