class AudioDownloader
  YT_DLP_COMMAND_PREFIX = " https://www.youtube.com/watch?v=".freeze
  YT_DLP_COMMAND_DOWNLOAD_AUDIO = " -f 140 --force-overwrites -o ".freeze

  attr_reader :audio_filepath

  def initialize(slug)
    @slug = slug
    @audio_filepath = Rails.root.join("tmp/audio/video_#{slug}/#{slug}.mp3")
  end

  def self.download(slug)
    new(slug).tap(&:download)
  end

  def download
    system((ENV["YT_DLP_BIN"] + YT_DLP_COMMAND_PREFIX + @slug + YT_DLP_COMMAND_DOWNLOAD_AUDIO + @audio_filepath.to_s))
  rescue => e
    Rails.logger.warn "Video::MusicRecognition::AcrCloud::Audio youtube-dl video fetching error: #{e.backtrace.join("\n\t")}"
    ""
  end
end
