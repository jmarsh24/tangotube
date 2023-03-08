# frozen_string_literal: true

SongMetadata =
  Struct.new(
    :titles,
    :song_url,
    :artist,
    :artist_url,
    :writers,
    :album,
    keyword_init: true
  )
