# frozen_string_literal: true

VideoCrawler = Struct.new(:slug, :youtube, :acrcloud, keyword_init: true) do
  def self.crawl(slug)
    new(
      slug: slug,
      youtube: YoutubeScraper.new.video_metadata(slug),
      acrcloud: MusicRecognizer.new.process_audio_snippet(slug)
    )
  end
end
