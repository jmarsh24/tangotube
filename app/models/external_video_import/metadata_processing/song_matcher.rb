# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      MATCH_THRESHOLD = 0.9
      STOP_WORDS = ["y su orquesta tipica"].freeze

      VideoData = Struct.new(:title, :description, :tags, :song_titles, :song_albums, :song_artists, keyword_init: true)

      def initialize
        @fuzzy_text = FuzzyText.new
        @songs = ::Song.joins(:orchestra).active.order(videos_count: :desc).to_a
      end

      def match(video_title:, video_description:, video_tags: [], song_titles: [], song_albums: [], song_artists: [])
        video_data = VideoData.new(
          title: video_title,
          description: video_description,
          tags: video_tags,
          song_titles:,
          song_albums:,
          song_artists:
        )
        artist_search_names = @songs.map(&:last_name_search).uniq.map(&:downcase)
        songs_with_artist_match = search_artist_match(video_data, artist_search_names)
        perfect_match = perfect_search_title_match(video_data, songs_with_artist_match)
        return perfect_match if perfect_match

        results = calculate_all_scores(video_data, songs_with_artist_match)

        highest_scoring_match(results)
      end

      private

      def search_artist_match(video_data, song_artists)
        songs_with_artist = []
        video_title_description = normalize([video_data.title, video_data.description, video_data.tags].join(" "))
        video_artist_metadata = normalize([video_data.song_albums, video_data.song_artists].flatten.join(" "))

        song_artists.each do |artist_name|
          if video_artist_metadata.include?(artist_name) || video_title_description.include?(artist_name)
            songs_with_artist << @songs.select { |song| song.last_name_search.downcase == artist_name }
          else
            artist_matches = {
              "artist_song_artist_in_video" => @fuzzy_text.jaro_winkler_score(artist_name.downcase, video_title_description),
              "artist_song_artist_in_metadata" => @fuzzy_text.jaro_winkler_score(artist_name.downcase, video_artist_metadata)
            }

            if artist_matches["artist_song_artist_in_video"] >= MATCH_THRESHOLD || artist_matches["artist_song_artist_in_metadata"] >= MATCH_THRESHOLD
              songs_with_artist << @songs.select { |song| song.last_name_search.downcase == artist_name }
            end
          end
        end

        songs_with_artist.flatten
      end

      def perfect_search_title_match(video_data, filtered_songs)
        video_title_search_string = "#{video_data.title} #{video_data.description} #{video_data.song_titles} #{video_data.song_albums} #{video_data.tags}"
        filtered_songs.each do |song|
          if video_title_search_string.include?(song.title)
            return song
          end
        end

        nil
      end

      def calculate_all_scores(video_data, songs)
        Rails.logger.info "Calculating scores for all songs..."
        start_time = Time.now

        perfect_match = nil

        scores_hash = songs.each_with_object({}) do |song, scores_hash|
          scores = calculate_scores_for_song(song, video_data)

          if scores["title_score"] >= 1.0 && scores["artist_score"] >= 1.0
            perfect_match = {song => scores}
            break
          end

          scores_hash[song] = scores
        end

        end_time = Time.now
        elapsed_time = end_time - start_time
        Rails.logger.info "Finished calculating scores for all songs. Elapsed time: #{elapsed_time.round(2)} seconds"

        perfect_match || scores_hash
      end

      def calculate_scores_for_song(song, video_data)
        start_time = Time.now
        Rails.logger.info "Calculating scores for song #{song.id}..."

        scores = calculate_scores(song, video_data)

        title_scores = scores.values_at("title_song_title_in_video", "title_song_search_title_in_video", "title_song_title_in_metadata", "title_song_search_title_in_metadata")
        artist_scores = scores.values_at("artist_song_artist_in_video", "artist_song_artist_in_metadata")

        title_score = title_scores.compact.max || 0
        artist_score = artist_scores.compact.max || 0

        scores.merge!(
          "title_score" => title_score,
          "artist_score" => artist_score,
          "is_match" => title_score > MATCH_THRESHOLD && artist_score > MATCH_THRESHOLD
        )

        end_time = Time.now
        elapsed_time = end_time - start_time
        Rails.logger.info "Finished calculating scores for song #{song.id}. Elapsed time: #{elapsed_time.round(2)} seconds"

        scores
      end

      def highest_scoring_match(results)
        best_matches = results.select { |song, scores| scores["is_match"] }
        highest_scoring_song = best_matches.max_by { |song, scores| [scores.values_at("title_score", "artist_score").sum, song.videos_count] }

        highest_scoring_song&.first
      end

      def calculate_scores(song, video_data)
        song_title = normalize(song.title)
        song_search_title = normalize(song.search_title)
        song_artist = normalize(song.artist)
        video_title_description = [normalize(video_data.title), normalize(video_data.description)].join(" ")

        perfect_artist_match = video_title_description.include?(song.last_name_search.downcase)

        {
          "title_song_title_in_video" => @fuzzy_text.jaro_winkler_score(song_title, video_title_description),
          "title_song_search_title_in_video" => (song_search_title =~ /\d/) ? @fuzzy_text.jaro_winkler_score(song_search_title, video_title_description) : 0,
          "title_song_title_in_metadata" => @fuzzy_text.jaro_winkler_score(song_title, video_data.song_titles.join(" ")),
          "title_song_search_title_in_metadata" => @fuzzy_text.jaro_winkler_score(song_search_title, video_data.song_titles.join(" ")),
          "artist_song_artist_in_video" => perfect_artist_match ? 1.0 : @fuzzy_text.jaro_winkler_score(song_artist, video_title_description),
          "artist_song_artist_in_metadata" => perfect_artist_match ? 1.0 : @fuzzy_text.jaro_winkler_score(song_artist, normalize(video_data.song_albums.join(" ") + video_data.song_artists.join(" ")))
        }
      end

      def normalize(text)
        return "" if text.nil?

        normalized_text = text.gsub("'", "").gsub("-", "").parameterize(separator: " ").downcase
        STOP_WORDS.each { |stop_word| normalized_text.gsub!(stop_word, "") }
        normalized_text.strip
      end
    end
  end
end
