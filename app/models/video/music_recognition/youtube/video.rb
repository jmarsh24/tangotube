class Video::MusicRecognition::Youtube::Video
  YOUTUBE_DL_COMMAND_PREFIX = "youtube-dl https://www.youtube.com/watch?v=".freeze
  YOUTUBE_DL_COMMAND_SUFFIX = " --skip-download --print-json".freeze

  class << self
    def import(youtube_id)
      new(youtube_id).import
    end
  end

  def initialize(youtube_id)
    @youtube_id = youtube_id
    @video = Video.find_by(youtube_id: youtube_id)
  end

  def import
    if @video.present?
      @video.update(video_params)
    else
      video_params
    end
  end

  private

  def fetch_youtube_video_info_by_id
    `#{YOUTUBE_DL_COMMAND_PREFIX + @youtube_id + YOUTUBE_DL_COMMAND_SUFFIX}`
    rescue StandardError => e
    Rails.logger.warn("Video::MusicRecognition::Youtube::Video youtube-dl video fetching error: #{e.backtrace.join("\n\t")}")
  end

  def parsed_response
    JSON.parse(fetch_youtube_video_info_by_id)
  end

  def video_params
    {
      youtube_song: parsed_response["track"],
      youtube_artist: parsed_response["artist"]
    }
  end
end
