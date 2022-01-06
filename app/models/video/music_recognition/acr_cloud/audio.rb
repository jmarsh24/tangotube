class Video::MusicRecognition::AcrCloud::Audio
  YOUTUBE_DL_COMMAND_PREFIX = "yt-dlp https://www.youtube.com/watch?v=".freeze
  YOUTUBE_DL_COMMAND_DOWNLOAD_AUDIO = " -f 140 --force-overwrites -o".freeze

  class << self
    def import(youtube_id)
      new(youtube_id).import
    end
  end

  def initialize(youtube_id)
    @youtube_id = youtube_id
  end

  def import
    fetch_audio_from_youtube
  end

  private

  def fetch_audio_from_youtube
    system(YOUTUBE_DL_COMMAND_PREFIX + @youtube_id + YOUTUBE_DL_COMMAND_DOWNLOAD_AUDIO + @file_path)
    rescue StandardError => e
      Rails.logger.warn "Video::MusicRecognition::AcrCloud::Audio youtube-dl video fetching error: #{e.backtrace.join("\n\t")}"
      ""
  end
end
