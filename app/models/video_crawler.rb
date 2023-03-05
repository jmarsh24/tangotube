class VideoCrawler
  attr_reader :youtube_scraper, :music_recognizer

  def initialize(youtube_scraper: YouTubeScraper.new, music_recognizer: MusicRecognizer.new)
    @youtube_scraper = youtube_scraper
    @music_recognizer = music_recognizer
  end

  def call(slug)
    VideoMetadata.new(
      youtube: youtube_scraper.video_metadata(slug)
      # accrloud: music_recognizer.process_audio_snippet(slug)
    )
  end
end
