class Video::YoutubeImport::Video
  class << self
    def import(youtube_id)
      new(youtube_id).import
    end
  end

  def initialize(youtube_id)
    @youtube_id = youtube_id
    @youtube_video = fetch_by_id
  end

  def import
    video = Video.find_or_create_by(youtube_id: @youtube_id)
    video.update(to_video_params)
    video.grep_title
  end

  private

  def fetch_by_id
    Yt::Video.new id: @youtube_id
  end

  def to_video_params
    base_params.merge(count_params).merge(channel: channel)
  end

  def base_params
    {
      youtube_id: @youtube_video.id,
      title: @youtube_video.title,
      description: @youtube_video.description,
      upload_date: @youtube_video.published_at,
      duration: @youtube_video.duration,
      tags: @youtube_video.tags,
      hd: @youtube_video.hd?,
      performance_date: performance_date
    }
  end


  def count_params
    {
      view_count: @youtube_video.view_count,
      favorite_count: @youtube_video.favorite_count,
      comment_count: @youtube_video.comment_count,
      like_count: @youtube_video.like_count,
      dislike_count: @youtube_video.dislike_count
    }
  end

  def performance_date
    performance_date = Date.parse(@youtube_video.description) || Date.parse(@youtube_video.title)
    rescue Date::Error
    performance_date
  end

  def channel
    @channel ||= Channel.find_or_create_by(channel_id: @youtube_video.channel_id)
    Video::YoutubeImport.from_channel(@channel.channel_id)
  end
end
