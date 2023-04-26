# frozen_string_literal: true

module ExternalVideoImport
  module MusicRecognition
    class AudioTrimmer
      def trim(audio_file)
        Tempfile.create(["#{File.basename(audio_file).to_s.split(".")[0]}_snippet", ".mp3"]) do |trimmed_file|
          transcode_audio_file(audio_file, trimmed_file)
          yield trimmed_file
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
  end
end
