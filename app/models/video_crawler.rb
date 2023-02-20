class VideoCrawler
  attr_reader :metadata

  def initialize(slug)
    @slug = slug
  end

  def self.crawl(slug)
    new(slug).tap(&:crawl)
  end

  def crawl
    @metadata = get_video_metadata
  end

  private

  def get_video_metadata
    {
      youtube: Youtube.fetch(slug: @slug).metadata,
      acrcloud: MusicRecognizer.process(slug: @slug).metadata
    }
  end
end
