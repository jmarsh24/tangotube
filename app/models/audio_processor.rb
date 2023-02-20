class AudioProcessor
  attr_reader :filepath

  def initialize(slug)
    @slug = slug
  end

  def self.process(slug:)
    new(slug).tap(&:process)
  end

  def process
    transcode_audio_file(external_audio, processed_audio)
    File.delete external_audio if external_audio && File.exist?(external_audio)
  end

  def processed_audio
    folder_path = File.dirname(external_audio)
    @filepath = folder_path.concat("/#{@slug}_snippet.mp3")
  end

  private

  def transcode_audio_file(input_file_path, output_file_path)
    audio_file = FFMPEG::Movie.new(input_file_path)
    start_time = audio_file.duration / 2
    end_time = start_time + 20
    audio_file.transcode(output_file_path, {custom: %W[-y -ss #{start_time} -to #{end_time}]})
  end

  def external_audio
    @external_audio ||= AudioDownloader.download(slug: @slug).filepath.to_s
  end
end
