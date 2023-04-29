module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      def match(metadata_fields:, genre:, artist_fields: nil, title_fields: nil, genre_fields: ["undefined"])
        text = [metadata_fields, artist_fields, title_fields].join(" ")
        song_data = Trigram.best_matches(list: all_songs, text: text, &song_match_block)

        find_or_create_song(song_data, title_fields, artist_fields, genre_fields)
      end

      private

      def all_songs
        ::Song.all.pluck(:id, :title, :last_name_search)
      end

      def song_match_block
        lambda { |song| [song[1], song[2]].join(" ") }
      end

      def find_or_create_song(song_data, title_fields, artist_fields, genre_fields)
        if song_data
          ::Song.find(song_data.first[0])
        else
          ::Song.create!(title: title_fields.first, artist: artist_fields.first, genre: genre_fields.first)
        end
      end
    end
  end
end
