class AudioTrimmer
  def trim(slug)
    Tempfile.create(["#{slug}_snippet", ".mp3"]) do |file|
      YoutubeAudioDownloader.new.with_download_file(slug) do |external_audio|
        transcode_audio_file(external_audio, file)
      end
      yield file
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
