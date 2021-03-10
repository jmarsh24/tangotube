class Video::MusicRecognition
  class << self
    def from_video(youtube_id)
      AcrCloud.fetch(youtube_id)
      Youtube.fetch(youtube_id)
    end
  end
end
