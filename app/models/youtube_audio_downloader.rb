# frozen_string_literal: true

class YoutubeAudioDownloader
  YT_DLP_COMMAND_PREFIX = "https://www.youtube.com/watch?v="
  YT_DLP_COMMAND_DOWNLOAD_AUDIO = "-f 140 --force-overwrites -o "

  def download_file(slug)
    full_length_audio_file = Tempfile.new([slug.to_s, ".mp3"])
    full_length_audio_file.binmode
    system(yt_dlp_command(full_length_audio_file, slug))
    full_length_audio_file.rewind
    File.open(full_length_audio_file.path)
  end

  private

  def yt_dlp_command(file, slug)
    "#{ENV["YT_DLP_BIN"]} '#{YT_DLP_COMMAND_PREFIX + slug}' #{YT_DLP_COMMAND_DOWNLOAD_AUDIO} #{file.path}"
  end
end
