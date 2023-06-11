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
        youtube.song&.titles&.first
      ].flatten.compact
    end

    def searchable_artist_names
      [
        music.spotify_artist_names,
        music.acr_artist_names,
        youtube.song&.titles&.first
      ].flatten.compact
    end

    def searchable_music_fields
      [
        music.acr_album_name,
        music.spotify_album_name,
        youtube.song&.album,
        youtube.song&.writers
      ].flatten.compact
    end

    def genre_fields
      track = RSpotify::Track.find(music.spotify_track_id)
      external_genres = track.artists.first.genres if track.present?
      [music.genre, external_genres].flatten.compact
    end
  end
end
