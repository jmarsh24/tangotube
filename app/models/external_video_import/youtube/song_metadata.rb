# frozen_string_literal: true

module ExternalVideoImport
  module Youtube
    class SongMetadata
      include StoreModel::Model

      attribute :titles, :array_of_strings, default: -> { [] }
      attribute :song_url, :string
      attribute :artist, :string
      attribute :artist_url, :string
      attribute :writers, :array_of_strings, default: -> { [] }
      attribute :album, :string
    end
  end
end
