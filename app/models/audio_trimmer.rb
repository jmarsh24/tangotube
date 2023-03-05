# frozen_string_literal: true

class AudioTrimmer
  def trim(audio_file)
    Tempfile.create(["#{audio_file.basename.to_s.split(".")[0]}_snippet", ".mp3"]) do |file|
      transcode_audio_file(audio_file.open, file)
      yield file if block_given?
    end
  end

  private

  def transcode_audio_file(input_file, output_file)
    audio_file = FFMPEG::Movie.new(input_file.path)
    start_time = audio_file.duration / 2
    end_time = start_time + 20
    audio_file.transcode(output_file.path, {custom: %W[-y -ss #{start_time} -to #{end_time}]})
  end
end
