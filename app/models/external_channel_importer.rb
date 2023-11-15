# frozen_string_literal: true

class ExternalChannelImporter
  def import(slug)
    Rails.logger.info("Starting import for channel: #{slug}")

    channel_metadata = fetch_metadata(slug)
    channel = Channel.create!(
      title: channel_metadata.title,
      youtube_slug: channel_metadata.id,
      description: channel_metadata.description,
      thumbnail_url: channel_metadata.thumbnail_url,
      metadata: channel_metadata,
      metadata_updated_at: Time.current
    )
    ThumbnailAttacher.new.attach_thumbnail(channel, channel_metadata.thumbnail_url)

    channel.sync_videos(use_music_recognizer: true)

    channel
  end

  def fetch_metadata(slug)
    youtube_channel = Yt::Channel.new(id: slug)

    ChannelMetadata.new(
      id: youtube_channel.id,
      title: youtube_channel.title,
      description: youtube_channel.description,
      published_at: youtube_channel.published_at,
      thumbnail_url: youtube_channel.thumbnail_url,
      view_count: youtube_channel.view_count,
      video_count: youtube_channel.video_count,
      video_ids: video_ids(youtube_channel),
      playlist_ids: youtube_channel.playlists.map(&:id),
      related_playlist_ids: youtube_channel.related_playlists.map(&:id),
      subscriber_count: youtube_channel.subscriber_count,
      privacy_status: youtube_channel.privacy_status
    )
  end

  private

  def video_ids(youtube_channel)
    if youtube_channel.video_count < 500
      youtube_channel.videos.map(&:id)
    else
      youtube_channel.related_playlists.first&.playlist_items&.map(&:video_id)
    end
  end
end
