# frozen_string_literal: true

module ExternalVideoImport
  module VideoCrawl
    module Youtube
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
    end
  end
end
