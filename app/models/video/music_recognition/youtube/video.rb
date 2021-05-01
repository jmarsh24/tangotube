class Video::MusicRecognition::Youtube::Video
  YOUTUBE_DL_COMMAND_PREFIX = "youtube-dl https://www.youtube.com/watch?v=".freeze
  YOUTUBE_DL_COMMAND_SUFFIX = " --skip-download --print-json".freeze

  class << self
    def import(youtube_id)
      new(youtube_id).import
    end
  end

  def initialize(youtube_id)
    @youtube_dl_json_response = fetch_youtube_video_info_by_id(youtube_id)
    @video = Video.find_by(youtube_id: youtube_id)
  end

  def import
    if @video.present?
      @video.update(video_params)
    else
      "Artist: #{video_params[:youtube_artist]}, Track: #{video_params[:youtube_song]}, but could not save because no internal video record found."
    end
  end

  private

  def fetch_youtube_video_info_by_id(youtube_id)
    `#{YOUTUBE_DL_COMMAND_PREFIX + youtube_id + YOUTUBE_DL_COMMAND_SUFFIX}`
    rescue StandardError => e
    Rails.logger.warn("Video::MusicRecognition::Youtube::Video youtube-dl video fetching error: #{e.backtrace.join("\n\t")}")
    ""
  end

  def parsed_response
    JSON.parse(@youtube_dl_json_response)
  end

  def video_params
    {
      youtube_song: parsed_response["track"],
      youtube_artist: parsed_response["artist"]
    }
  end
end
