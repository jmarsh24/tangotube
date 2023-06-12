class ExternalChannelImporter
  def import(slug)
    Rails.logger.info("Starting import for channel: #{slug}")

    youtube_channel = Yt::Channel.new(id: slug)

    channel_video_count = youtube_channel.video_count

    ChannelMetadata.new(
      id: youtube_channel.id,
      title: youtube_channel.title,
      description: youtube_channel.description,
      published_at: youtube_channel.published_at,
      thumbnail_url: youtube_channel.thumbnail_url,
      view_count: youtube_channel.view_count,
      video_count: youtube_channel.video_count,
      video_ids: fetch_video_ids(youtube_channel, channel_video_count),
      playlist_ids: fetch_playlist_ids(youtube_channel),
      related_playlist_ids: fetch_related_playlist_ids(youtube_channel),
      subscriber_count: youtube_channel.subscriber_count,
      privacy_status: youtube_channel.privacy_status
    )
  end

  private

  def fetch_playlist_ids(youtube_channel)
    playlist_ids = youtube_channel.playlists.map(&:id)
    Rails.logger.info("Fetched playlist ids for channel: #{youtube_channel.id}")
    playlist_ids
  end

  def fetch_related_playlist_ids(youtube_channel)
    related_playlist_ids = youtube_channel.related_playlists.map(&:id)
    Rails.logger.info("Fetched related playlist ids for channel: #{youtube_channel.id}")
    related_playlist_ids
  end

  def fetch_video_ids(youtube_channel, channel_video_count)
    video_ids = if channel_video_count < 500
      youtube_channel.videos.map(&:id)
    else
      youtube_channel.related_playlists.first&.playlist_items&.map(&:video_id)
    end
    Rails.logger.info("Fetched video ids for channel: #{youtube_channel.id}")
    video_ids
  end
end
