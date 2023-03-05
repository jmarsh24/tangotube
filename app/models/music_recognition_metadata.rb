MusicRecognitionMetadata =
  Struct.new(
    :code,
    :message,
    :acr_song_title,
    :acr_artist_names,
    :acr_album_name,
    :acrid,
    :isrc,
    :genre,
    :spotify_artist_names,
    :spotify_track_name,
    :spotify_track_id,
    :spotify_album_name,
    :spotify_album_id,
    :youtube_vid,
    keyword_init: true
  )
