# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      MATCH_THRESHOLD = 0.9
      STOP_WORDS = ["y su orquesta tipica"].freeze

      VideoData = Struct.new(:title, :description, :song_titles, :song_albums, :song_artists, keyword_init: true)

      @@songs_cache = nil

      def initialize
        @fuzzy_text = FuzzyText.new
        @@songs_cache ||= ::Song.joins(:orchestra).active.to_a
      end

      def match(video_title:, video_description:, song_titles: [], song_albums: [], song_artists: [])
        video_data = VideoData.new(
          title: video_title,
          description: video_description,
          song_titles:,
          song_albums:,
          song_artists:
        )

        results = calculate_all_scores(video_data)

        highest_scoring_match(results)
      end

      private

      def calculate_all_scores(video_data)
        @@songs_cache.index_with do |song|
          calculate_scores_for_song(song, video_data)
        end
      end

      def calculate_scores_for_song(song, video_data)
        scores = calculate_scores(song, video_data)

        title_score = scores.values_at(*scores.keys.grep(/title/)).max || 0
        artist_score = scores.values_at(*scores.keys.grep(/artist/)).max || 0

        scores.merge("title_score" => title_score, "artist_score" => artist_score, "is_match" => title_score > MATCH_THRESHOLD && artist_score > MATCH_THRESHOLD)
      end

      def highest_scoring_match(results)
        best_matches = results.select { |_song, scores| scores["is_match"] }
        highest_scoring_song = best_matches.max_by { |song, scores| [scores.values_at("title_score", "artist_score").sum, song.videos_count] }

        highest_scoring_song&.first
      end

      def calculate_scores(song, video_data)
        song_title = normalize(song.title)
        song_search_title = normalize(song.search_title)
        song_artist = normalize(song.artist)
        video_title = normalize(video_data.title)
        video_description = normalize(video_data.description)

        {
          "title_song_title_in_video" => @fuzzy_text.jaro_winkler_score(song_title, [video_title, video_description].join(" ")),
          "title_song_search_title_in_video" => @fuzzy_text.jaro_winkler_score(song_search_title, [video_title, video_description].join(" ")),
          "title_song_title_in_metadata" => @fuzzy_text.jaro_winkler_score(song_title, video_data.song_titles.join(" ")),
          "title_song_search_title_in_metadata" => @fuzzy_text.jaro_winkler_score(song_search_title, video_data.song_titles.join(" ")),
          "artist_song_artist_in_video" => @fuzzy_text.jaro_winkler_score(song_artist, [video_title, video_description].join(" ")),
          "artist_song_artist_in_metadata" => @fuzzy_text.jaro_winkler_score(song_artist, normalize(video_data.song_albums.join(" ") + video_data.song_artists.join(" ")))
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
