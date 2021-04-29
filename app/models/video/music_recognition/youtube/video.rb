class Video::MusicRecognition::Youtube::Video
  YOUTUBE_DL_COMMAND_PREFIX = "https://www.youtube.com/watch?v=".freeze
  YOUTUBE_DL_COMMAND_SUFFIX = "--skip-download".freeze

  class << self
    def import(video_id)
      new(video_id).import
    end
  end

  def initialize(youtube_id)
    @youtube_id = youtube_id
    @youtube_video = fetch_by_id(youtube_id)
    @video = Video.find_by(youtube_id: youtube_id)
  end

  def import
    @video.update(video_params)
  end

  private

  def fetch_by_id
    `#{YOUTUBE_DL_COMMAND_PREFIX + @youtube_id + YOUTUBE_DL_COMMAND_SUFFIX}`.split
    rescue StandardError => e
      Rails.logger.warn "Video::MusicRecognition::Youtube::Video youtube-dl video fetching error: #{e.backtrace.join("\n\t")}"
      ""
  end

  def parsed_response
    JSON.parse(@youtube_video.to_json).extend Hashie::Extensions::DeepFind
  end

  def video_params
    {
      youtube_song: parsed_response.deep_find("track"),
      youtube_artist: parsed_response.deep_find("artist")
    }
  end
end
