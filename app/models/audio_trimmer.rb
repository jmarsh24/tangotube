# frozen_string_literal: true

class AudioTrimmer
  def trim(audio_file)
    trimmed_file = Tempfile.new(["#{File.basename(audio_file).to_s.split(".")[0]}_snippet", ".mp3"])
    trimmed_file.binmode
    transcode_audio_file(audio_file, trimmed_file)
    yield trimmed_file if block_given?
    trimmed_file
  end

  private

  def transcode_audio_file(input_file, output_file)
    audio_file = FFMPEG::Movie.new(input_file.path)
    start_time = audio_file.duration / 2
    end_time = start_time + 20
    audio_file.transcode(output_file.path, {custom: %W[-y -ss #{start_time} -to #{end_time}]})
  end
end
