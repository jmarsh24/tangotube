class VideoCrawler
  def crawl(slug)
    {
      youtube: Youtube.new.fetch(slug: slug),
      acrcloud: MusicRecognizer.new.process_audio_snippet(slug: slug)
    }
  end
end
