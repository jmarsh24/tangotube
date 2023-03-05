# frozen_string_literal: true

SongMetadata =
  Struct.new(
    :title,
    :artist,
    :album,
    keyword_init: true
  )
