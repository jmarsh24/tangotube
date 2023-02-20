class MusicRecognizer
  attr_reader :metadata

  def self.process(slug:)
    new(slug).tap(&:process)
  end

  def initialize(slug)
    @slug = slug
    @metadata = {}
  end

  def process
    @metadata = acr_metadata
    File.delete audio_file if audio_file && File.exist?(audio_file)
  end

  private

  def acr_metadata
    @acr_metadata ||= AcrCloud.send(audio_file:).data
  end

  def audio_file
    @audio_file ||= AudioProcessor.process(slug: @slug).filepath.to_s
  end
end
