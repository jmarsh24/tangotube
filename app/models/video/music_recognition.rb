# frozen_string_literal: true

class Video::MusicRecognition
  class << self
    def from_youtube_id(youtube_id)
      AcrCloud.fetch(youtube_id)
      Youtube.fetch(youtube_id)
    end
  end
end
