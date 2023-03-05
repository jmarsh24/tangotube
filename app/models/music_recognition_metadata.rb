MusicRecognitionMetadata =
  Struct.new(
    :code,
    :message,
    :acr_title,
    :acr_album_name,
    :acrid,
    :isrc,
    :genre,
    :spotify_artist_names,
    :spotify_track_name,
    :spotify_album_name,
    :youtube_vid,
    keyword_init: true
  )
