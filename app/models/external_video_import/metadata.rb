module ExternalVideoImport
  class Crawler
    Metadata = Struct.new(
      :youtube,
      :music,
      keyword_init: true
    ) do
      def searchable_song_titles
        [
          music.acr_song_title,
          music.spotify_track_name,
          youtube.song.titles
        ]
      end

      def searchable_artist_names
        [
          music.spotify_artist_names,
          music.acr_artist_names,
          youtube.song.artist
        ]
      end

      def searchable_music_fields
        [
          music.acr_album_name,
          music.spotify_album_name,
          youtube.song.album,
          youtube.writers
        ]
      end

      def genre_fields
        external_genres = RSpotify::Track.find(music.spotify_track_id).genres
        [music.genre, external_genres]
      end
    end
  end
end
