class Video::MusicRecognition::Youtube::Video
  class << self
    def import(video_id)
      new(video_id).import
    end
  end

  def initialize(youtube_id)
    @youtube_video = fetch_by_id(youtube_id)
    @video = Video.find_by(youtube_id: youtube_id)
  end

  def import
    byebug
    @video.update(video_params)
  end

  private

  def fetch_by_id(youtube_id)
    YoutubeDL.download("https://www.youtube.com/watch?v=#{youtube_id}", skip_download: true)
  end

  def parsed_response
    JSON.parse(@youtube_video.to_json).extend Hashie::Extensions::DeepFind
  end

  def video_params
    {
      youtube_song:   parsed_response.deep_find("track"),
      youtube_artist: parsed_response.deep_find("artist")
    }
  end
end
