class SongSnippet
  attr_reader :filepath

  def initialize(slug)
    @slug = slug
  end

  def self.create(slug:)
    new(slug).tap(&:create)
  end

  def create
    @filepath = AudioProcessor.process(slug: @slug).filepath
  end
end
