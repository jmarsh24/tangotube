class AudioProcessor
  def initialize(audio_filepath)
    @audio_filepath = audio_filepath
  end

  def self.process(audio_filepath)
    new(audio_filepath).tap(&:process)
  end

  def process
    transcode_audio_file(@audio_filepath.to_s, snippet_filepath.to_s)
  end

  def snippet_filepath
    folder_path = File.dirname(@audio_filepath)
    new_filename = File.basename(@audio_filepath, ".*").concat("_snippet.mp3")
    @snippet_filepath ||= File.join(folder_path, new_filename)
  end

  private

  def transcode_audio_file(input_file_path, output_file_path)
    audio_file = FFMPEG::Movie.new(input_file_path)
    start_time = audio_file.duration / 2
    end_time = start_time + 20
    audio_file.transcode(output_file_path, {custom: %W[-y -ss #{start_time} -to #{end_time}]})
  end
end
