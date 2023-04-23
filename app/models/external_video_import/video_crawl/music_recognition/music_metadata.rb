# frozen_string_literal: true

module ExternalVideoImport
  module VideoCrawl
    module MusicRecognition
      MusicMetadata =
        Struct.new(
          :status,
          :msg,
          :title,
          :artist,
          :acr_id,
          :isrc,
          :acr_artist_names,
          :acr_album_name,
          :spotify_artist_name,
          :spotify_track_name,
          :spotify_track_id,
          :spotify_album_name,
          :youtube_video_id,
          keyword_init: true
        )
    end
  end
end
