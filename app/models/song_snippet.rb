class SongSnippet
  attr_reader :filepath

  def initialize(slug)
    @slug = slug
  end

  def self.create(slug)
    new(slug).tap(&:create)
  end

  def create
    @filepath = AudioProcessor.process(audio_filepath).snippet_filepath
  end

  private

  def audio_filepath
    AudioDownloader.download(@slug).audio_filepath
  end
end
