MusicMetadata =
  Struct.new(
    :status,
    :msg,
    :title,
    :artist,
    :acrid,
    :isrc,
    :acr_artist_name,
    :acr_album_name,
    :spotify_artist_name,
    :spotify_track_name,
    :spotify_track_id,
    :spotify_album_name,
    :youtube_video_id,
    keyword_init: true
  )
