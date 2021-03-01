class Video::YoutubeImport::Video
  class << self
    def import(video_id)
      new(video_id).import
    end
  end

  def initialize(youtube_id)
    @youtube_video = JSON.parse(fetch_by_id(youtube_id)).extend Hashie::Extensions::DeepFind
    @video = Video.find_by(youtube_id: youtube_id)
  end

  def update
    @video.update(video_params)
  end

  private

  def fetch_by_id(youtube_id)
    YoutubeDL.download("https://www.youtube.com/watch?v=#{youtube_id}", skip_download: true).to_json
  end

  def video_params
    {
      youtube_song:   @youtube_video.deep_find("track"),
      youtube_artist: @youtube_video.deep_find("artist")
    }
  end
end
