# frozen_string_literal: true

YoutubeChannelMetadata =
  Struct.new(
    :id,
    :title,
    :description,
    :published_at,
    :thumbnail_url,
    :view_count,
    :video_count,
    :subscriber_count,
    :content_owner,
    :videos,
    :playlists,
    :related_playlists,
    :subscribed_channels,
    :privacy_status,
    keyword_init: true
  )
