# frozen_string_literal: true

module ExternalVideoImport
  module MusicRecognition
    class MusicRecognizer
      class Metadata
        include StoreModel::Model

        attribute :code, :integer
        attribute :message, :string
        attribute :acr_song_title, :string
        attribute :acr_artist_names, :array_of_strings, default: -> { [] }
        attribute :acr_album_name, :string
        attribute :acr_id, :string
        attribute :isrc, :string
        attribute :genre, :string
        attribute :spotify_artist_names, :array_of_strings, default: -> { [] }
        attribute :spotify_track_name, :string
        attribute :spotify_track_id, :string
        attribute :spotify_album_name, :string
        attribute :spotify_album_id, :string
        attribute :youtube_vid, :string
      end
    end
  end
end
