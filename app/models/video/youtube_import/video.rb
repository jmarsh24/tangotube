class Video::YoutubeImport::Video
  PERFORMANCE_REGEX=/(?<=\s|^|#)[1-8]\s?(of|de|\/|-)\s?[1-8](\s+$|)/

  class << self
    def import(youtube_id)
      new(youtube_id).import
    end

    def update(youtube_id)
      new(youtube_id).update
    end
  end

  def initialize(youtube_id)
    @youtube_id = youtube_id
    @youtube_video = fetch_by_id
    @video = Video.find_or_create_by!(youtube_id: @youtube_id, channel:)
  end

  def import
    @video.update(video_params)
    if @video.leader.nil? || @video.follower.nil?
      @video.grep_title_for_dancer
    end
    if @video.performance_number.nil? || @video.performance_total_number.nil?
      @video.grep_performance_number
    end
    rescue Yt::Errors::NoItems, JSON::ParserError => e
    if e.present?
      @video.destroy
    end
    unless @video.channel.active?
      @video.destroy
    end
    @video.save
  end

  def update
    @video.update(update_video_params)
    if @video.leader.nil? || @video.follower.nil?
      @video.grep_title_for_dancer
    end
    if @video.performance_number.nil? || @video.performance_total_number.nil?
      @video.grep_performance_number
    end
    unless @video.acr_response_code.in? [0,1001]
      Video::MusicRecognition::AcrCloud.fetch(@youtube_id)
    end
    if @video.youtube_song.nil?
      Video::MusicRecognition::Youtube.fetch(@youtube_id)
    end
    if @video.song.nil?
      @video.grep_title_description_acr_cloud_song
    end
    rescue Yt::Errors::NoItems, JSON::ParserError => e
    if e.present?
      @video.destroy
    end
    @video.save
  end

  private

  def fetch_by_id
    Yt::Video.new id: @youtube_id
  end

  def video_params
    base_params.merge(count_params).merge(performance_date_params).merge(channel:)
  end

  def update_video_params
    base_params.merge(count_params).merge(channel:)
  end

  def base_params
    {
      youtube_id: @youtube_video.id,
      title: @youtube_video.title,
      description: @youtube_video.description,
      upload_date: @youtube_video.published_at,
      duration: @youtube_video.duration,
      tags: @youtube_video.tags,
      hd: @youtube_video.hd?
    }
  end

  def performance_date_params
    {
      performance_date: @youtube_video.published_at
    }
  end

  def count_params
    {
      view_count: @youtube_video.view_count,
      favorite_count: @youtube_video.favorite_count,
      comment_count: @youtube_video.comment_count,
      like_count:,
      dislike_count: @youtube_video.dislike_count
    }
  end

  def like_count
    like_count = @youtube_video.like_count
    like_count = 0 if like_count.nil?
    like_count
  end

  def channel
    @channel ||= Channel.find_by(channel_id: @youtube_video.channel_id)
    if @channel.nil?
      Video::YoutubeImport::Channel.import(@youtube_video.channel_id)
      @channel ||= Channel.find_by(channel_id: @youtube_video.channel_id)
      ImportChannelWorker.perform_async(@youtube_video.channel_id)
    end
    @channel
  end
end
