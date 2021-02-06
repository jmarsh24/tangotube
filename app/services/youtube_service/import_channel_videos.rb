class YoutubeService::ImportChannelVideos
  def initialize(channel:)
    @channel = channel
    @response = ServiceResponse.new
  end

  def call
    import_videos
    @response.return
  end

  private

  def import_videos
    youtube_channel = Yt::Channel.new(id: @channel.youtube_channel_id)
    youtube_channel.videos.each do |youtube_video|
      next if Video.where(youtube_id: youtube_video.id).any?

      @channel.videos.create!(
        youtube_id: youtube_video.id,
        title: youtube_video.title,
        description: youtube_video.description,
        upload_date: youtube_video.published_at,
        duration: youtube_video.duration,
        view_count: youtube_video.view_count,
        tags: youtube_video.tags,
        hd: youtube_video.hd?,
        favorite_count: youtube_video.favorite_count,
        comment_count: youtube_video.comment_count,
        like_count: youtube_video.like_count,
        dislike_count: youtube_video.dislike_count
      )

      imported_videos_count = Video.where(channel: channel).count
      imported = imported_videos_count >= channel.total_videos_count

      @channel.update(
        imported_videos_count: imported_videos_count,
        title: yt_channel.title,
        thumbnail_url: yt_channel.thumbnail_url,
        total_videos_count: yt_channel.video_count
      )
    end
  end
end
