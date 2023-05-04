# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      def match_or_create(metadata_fields:, artist_fields: nil, title_fields: nil, genre_fields: ["undefined"])
        text = [metadata_fields, artist_fields, title_fields].join(" ")
        best_matches = Trigram.best_matches(list: all_songs, text:, &song_match_block)

        find_or_create_songs(best_matches, title_fields, artist_fields, genre_fields)
      end

      private

      def all_songs
        ::Song.all.pluck(:id, :title, :last_name_search)
      end

      def song_match_block
        lambda { |song| [song[1], song[2]].join(" ") }
      end

      def find_or_create_songs(matches, title_fields, artist_fields, genre_fields)
        songs = []
        matches.each do |match|
          song_id = match.first[0]
          songs << ::Song.find(song_id)
        end

        if songs.empty?
          songs << ::Song.create!(title: title_fields.first, artist: artist_fields.first, genre: genre_fields.first)
        end

        songs
      end
    end
  end
end
