# frozen_string_literal: true

class ExternalChannelImporter
  def import(slug)
    Rails.logger.info("Starting import for channel: #{slug}")

    channel_metadata = create_metadata(slug)

    Channel.create!(
      title: channel_metadata.title,
      channel_id: channel_metadata.id,
      description: channel_metadata.description,
      thumbnail_url: channel_metadata.thumbnail_url,
      metadata: channel_metadata,
      metadata_updated_at: Time.current
    )
  rescue => e
    Rails.logger.info("Error while processing channel with slug: #{slug}. Error: #{e.message}")
    raise e
  end

  def fetch_metadata(slug)
    create_metadata(slug)
  rescue => e
    Rails.logger.info("Error while processing channel with slug: #{slug}. Error: #{e.message}")
    raise e
  end

  private

  def create_metadata(slug, channel_video_count = nil)
    youtube_channel = Yt::Channel.new(id: slug)
    channel_video_count ||= youtube_channel.video_count

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

  def fetch_video_ids(youtube_channel, channel_video_count)
    video_ids = if channel_video_count.to_i < 500
      youtube_channel.videos.map(&:id)
    else
      youtube_channel.related_playlists.first&.playlist_items&.map(&:video_id)
    end

    Rails.logger.info("Fetched video ids for channel: #{youtube_channel.id}")

    video_ids
  end

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
end
