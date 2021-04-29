class Video::YoutubeImport::Channel
  YOUTUBE_DL_COMMAND_PREFIX =
    "youtube-dl https://www.youtube.com/channel/".freeze
  YOUTUBE_DL_COMMAND_SUFFIX = "/videos  --get-id --skip-download".freeze

  class << self
    def import(channel_id)
      new(channel_id).import
    end

    def import_videos(channel_id)
      new(channel_id).import_videos
    end
  end

  def initialize(channel_id)
    @channel_id = channel_id
    @youtube_channel = fetch_by_id(channel_id)
    @channel = channel
  end

  def import
    channel.update(to_channel_params)
  end

  def import_videos
    new_videos.each { |youtube_id| ImportVideoWorker.perform_async(youtube_id) }
  end

  private

  def fetch_by_id(_channel_id)
    Yt::Channel.new id: @channel_id
  end

  def channel
    @channel ||= Channel.find_or_create_by(channel_id: @channel_id)
  end

  def to_channel_params
    base_params.merge(count_params)
  end

  def base_params
    {
      channel_id: @youtube_channel.id,
      title: @youtube_channel.title,
      thumbnail_url: @youtube_channel.thumbnail_url
    }
  end

  def count_params
    { total_videos_count: @youtube_channel.video_count }
  end

  def get_channel_video_ids
    `#{YOUTUBE_DL_COMMAND_PREFIX + @channel_id + YOUTUBE_DL_COMMAND_SUFFIX}`.split
  rescue StandardError => e
    Rails
      .logger.warn "Video::YoutubeImport::Channel youtube-dl video fetching error: #{e.backtrace.join("\n\t")}"
    "" # NOTE: the empty string return so your split method works always.
  end

  def youtube_channel_video_ids
    if @youtube_channel.video_count >= 500
      get_channel_video_ids
    else
      @youtube_channel.videos.map(&:id)
    end
  end

  def channel_existing_youtube_video_ids
    channel.videos.pluck(:youtube_id)
  end

  def new_videos
    youtube_channel_video_ids - channel_existing_youtube_video_ids
  end
end
