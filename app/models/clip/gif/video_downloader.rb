# frozen_string_literal: true

class Clip::Gif::VideoDownloader
  DOWNLOAD_PATH = "/tmp"
  URL_PREFIX = "https://youtube.com/watch?v="

  class << self
    def download(youtube_id)
      downloader = new(youtube_id)
      downloader.download
      downloader
    end
  end

  def initialize(youtube_id)
    @youtube_id = youtube_id
  end

  def url
    (URL_PREFIX + @youtube_id).to_s
  end

  def download
    system("yt-dlp -f 140 '#{url}' -o #{download_path}")
  end

  def download_path
    File.join(DOWNLOAD_PATH, target_file_name)
  end

  private

  def target_file_name
    "#{@youtube_id}.mp4"
  end
end
