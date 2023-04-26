module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      def match(video_metadata)
        songs = ::Song.all.pluck(:id, :title, :last_name_search)
        text = [video_metadata.music.song_field, video_metadata.music.artist_field].join(" ")
        song_data = Trigram.best_match(list: songs, text:) do |song|
          [song[1], song[2]].join(" ")
        end
        if song_data
          ::Song.find(song_data[0])
        else
          ::Song.create(title: video_metadata.music.song_field, artist_name: video_metadata.music.artist_field)
        end
      end
    end
  end
end
