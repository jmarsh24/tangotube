# frozen_string_literal: true

module ExternalVideoImport
  module MusicRecognition
    class AudioTrimmer
      def trim(file)
        return unless File.exist?(file.path) && !File.zero?(file.path)

        media = FFMPEG::Movie.new(file.path)
        file_to_trim = media.video_stream ? transcode_and_trim(media) : file

        Tempfile.create(["#{File.basename(file_to_trim.path, File.extname(file_to_trim.path))}_trimmed", ".mp3"]) do |trimmed_file|
          transcode_audio_file(file_to_trim, trimmed_file)
          yield trimmed_file
        end
      rescue => e
        Rails.logger.error "Failed to trim audio: #{e.message}"
      end

      private

      def transcode_and_trim(media)
        audio_file = Tempfile.new([File.basename(media.path, File.extname(media.path)), ".mp3"])
        media.transcode(audio_file.path, audio_codec: "mp3")
        audio_file
      end

      def transcode_audio_file(input_file, output_file)
        audio_file = FFMPEG::Movie.new(input_file.path)
        start_time = audio_file.duration / 2
        end_time = start_time + 20
        audio_file.transcode(output_file.path, {custom: ["-y", "-ss", start_time.to_s, "-to", end_time.to_s]})
      end
    end
  end
end
