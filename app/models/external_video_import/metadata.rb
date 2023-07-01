# frozen_string_literal: true

module ExternalVideoImport
  class Metadata < Crawler
    include StoreModel::Model

    attribute :youtube, Youtube::VideoMetadata.to_type
    attribute :music, MusicRecognition::Metadata.to_type

    def searchable_song_titles
      [
        music.acr_song_title,
        music.spotify_track_name,
        youtube.song.titles.first
      ].flatten.compact
    end

    def searchable_artist_names
      [
        music.spotify_artist_names,
        music.acr_artist_names,
        youtube.song.titles.first
      ].flatten.compact
    end

    def genre_fields
      external_genres = []
      if music.spotify_artist_ids.any?(&:present?)
        music.spotify_artist_ids.compact.each do |artist_id|
          external_genres << SpotifyArtistFinder.new.find(artist_id).dig("genres")
        rescue => e
          puts "Error retrieving Spotify artist genres: #{e.message}"
        end
      end
      [music.genre, external_genres].flatten.compact
    end
  end
end
