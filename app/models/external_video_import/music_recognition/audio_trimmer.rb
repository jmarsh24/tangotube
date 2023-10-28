# frozen_string_literal: true

module ExternalVideoImport
  module MusicRecognition
    class AudioTrimmer
      def trim(file)
        return unless File.exist?(file.path) && !File.zero?(file.path)

        transcoded_file = transcode_to_mp3(file)

        Tempfile.create(["#{File.basename(transcoded_file.path, File.extname(transcoded_file.path))}_trimmed", ".mp3"]) do |trimmed_file|
          trim_audio_file(transcoded_file, trimmed_file)
          yield trimmed_file if block_given?
        end
      rescue => e
        Rails.logger.error "Failed to trim audio: #{e.message}"
      end

      private

      def transcode_to_mp3(file)
        return file if File.extname(file.path).casecmp(".mp3").zero?

        audio_file = Tempfile.new([File.basename(file.path, File.extname(file.path)), ".mp3"])
        media = FFMPEG::Movie.new(file.path)
        media.transcode(audio_file.path, audio_codec: "mp3")
        audio_file
      end

      def trim_audio_file(input_file, output_file)
        audio_file = FFMPEG::Movie.new(input_file.path)
        start_time = audio_file.duration / 2
        end_time = start_time + 20
        audio_file.transcode(output_file.path, {custom: ["-y", "-ss", start_time.to_s, "-to", end_time.to_s]})
      end
    end
  end
end
