class Video::MusicRecognition
  class << self
    def from_video(youtube_id)
      AcrCloud.import(youtube_id)
    end
  end
end
