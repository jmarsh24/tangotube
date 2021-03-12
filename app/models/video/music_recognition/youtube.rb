class Video::MusicRecognition::Youtube
  class << self
    def from_youtube_id(youtube_id)
      Video.import(youtube_id)
    end
  end
end
