  class Video::MusicRecognition::Youtube
  YOUTUBE_DL_COMMAND_PREFIX = "yt-dlp \"https://www.youtube.com/watch?v=".freeze
  YOUTUBE_DL_COMMAND_SUFFIX = "\" --skip-download --print-json".freeze

  class << self
    def fetch(youtube_id)
      new(youtube_id).import
    end
  end

  def initialize(youtube_id)
    @youtube_id = youtube_id
    @youtube_dl_json_response = fetch_youtube_video_info_by_id
    @video = Video.find_by(youtube_id:)
  end

  def import
    if @video.present?
      @video.update(video_params)
    else
      "Artist: #{video_params[:youtube_artist]}, Track: #{video_params[:youtube_song]}, but could not save because no internal video record found."
    end
  end

  private

  def fetch_youtube_video_info_by_id
    throttle = RateThrottleClient::ExponentialIncreaseProportionalRemainingDecrease.new

    response = throttle.call do
      youtube_response = `#{YOUTUBE_DL_COMMAND_PREFIX + @youtube_id} + #{YOUTUBE_DL_COMMAND_SUFFIX}`
      rescue StandardError => e
      Rails.logger.warn("Video::MusicRecognition::Youtube yt-dlp video fetching error: #{e.backtrace.join("\n\t")}")
      ""
      puts "youtube-dl-print-out" youtube_response
      youtube_response
    end
    puts response
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
