class AudioDownloader
  YT_DLP_COMMAND_PREFIX = " https://www.youtube.com/watch?v=".freeze
  YT_DLP_COMMAND_DOWNLOAD_AUDIO = " -f 140 --force-overwrites -o ".freeze

  def initialize(slug)
    @slug = slug
    @filepath = Rails.root.join("tmp/audio/video_#{slug}/#{slug}.mp3")
  end

  def self.download(slug:)
    new(slug).with_download_file do |file|
      yield file
    end
  end

  def with_download_file
    Tempfile.create(@slug.to_s) do |file|
      system(yt_dlp_command(file))
      file
    rescue => e
      Rails.logger.warn "AudioDownloader yt-dlp download error: #{e.backtrace.join("\n\t")}"
    end
  end

  def yt_dlp_command(file)
    ENV["YT_DLP_BIN"] + YT_DLP_COMMAND_PREFIX + @slug + YT_DLP_COMMAND_DOWNLOAD_AUDIO + file.path
  end
end
