class MusicRecognizer
  def process_audio_snippet(slug)
    AudioTrimmer.new.trim(slug) do |trimmed_audio|
      AcrCloud.new.upload(trimmed_audio)
    end
  end
end
