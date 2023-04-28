module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      def match(artist_fields:, title_fields:, metadata_fields:)
        songs = ::Song.all.pluck(:id, :title, :last_name_search)
        text = [metadata_fields, artist_fields, title_fields].join(" ")
        song_data = Trigram.best_matches(list: songs, text:) do |song|
          [song[1], song[2]].join(" ")
        end
        if song_data
          ::Song.find(song_data.first[0])
        else
          ::Song.create(title: video_metadata.music.song_field, artist_name: video_metadata.music.artist_field)
        end
      end
    end
  end
end
