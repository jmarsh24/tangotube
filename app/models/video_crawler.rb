# frozen_string_literal: true

class VideoCrawler
  def crawl(slug)
    {
      youtube: Youtube.new(slug).metadata,
      acrcloud: MusicRecognizer.new.process_audio_snippet(slug)
    }
  end
end
