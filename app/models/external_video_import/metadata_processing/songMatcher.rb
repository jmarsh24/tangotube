# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      def match(metadata_fields:, genre:, artist_fields: nil, title_fields: nil, genre_fields: ["undefined"])
        text = [metadata_fields, artist_fields, title_fields].join(" ")
        best_match = Trigram.best_matches(list: all_songs, text: text, &song_match_block).first

        find_or_create_song(best_match, title_fields, artist_fields, genre_fields)
      end

      private

      def all_songs
        ::Song.all.pluck(:id, :title, :last_name_search)
      end

      def song_match_block
        lambda { |song| [song[1], song[2]].join(" ") }
      end

      def find_or_create_song(best_match, title_fields, artist_fields, genre_fields)
        if best_match
          ::Song.find(best_match.first[0])
        else
          ::Song.create!(title: title_fields.first, artist: artist_fields.first, genre: genre_fields.first)
        end
      end
    end
  end
end
