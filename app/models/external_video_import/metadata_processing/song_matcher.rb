# frozen_string_literal: true

require "fuzzystringmatch"

module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      MATCH_THRESHOLD = 0.9
      STOP_WORDS = ["y", "su", "orquesta", "tipica"].freeze

      VideoData = Struct.new(:title, :description, :song_titles, :song_albums, :song_artists, keyword_init: true)

      def initialize
        @jarow = FuzzyStringMatch::JaroWinkler.create(:pure)
      end

      def match(video_title:, video_description:, song_titles: [], song_albums: [], song_artists: [])
        video_data = VideoData.new(
          title: video_title,
          description: video_description,
          song_titles:,
          song_albums:,
          song_artists:
        )

        initialize_match_variables

        ::Song.joins(:orchestra).active.find_each do |song|
          calculate_scores_for_song(song, video_data)
          determine_best_match(song)
        end

        @best_match
      end

      def match_with_scores(video_title:, video_description:, song_titles: [], song_albums: [], song_artists: [])
        video_data = VideoData.new(
          title: video_title,
          description: video_description,
          song_titles:,
          song_albums:,
          song_artists:
        )

        initialize_match_variables

        ::Song.joins(:orchestra).active.find_each do |song|
          calculate_scores_for_song(song, video_data)
          determine_best_match(song)
        end

        @results
      end

      private

      def initialize_match_variables
        @best_match = nil
        @best_score = 0
        @results = {}
      end

      def calculate_scores_for_song(song, video_data)
        scores = calculate_scores(song, video_data)

        title_score = find_max_score(scores, "title")
        artist_score = find_max_score(scores, "artist")

        scores["title_score"] = title_score
        scores["artist_score"] = artist_score
        scores["is_match"] = title_score > MATCH_THRESHOLD && artist_score > MATCH_THRESHOLD

        @results[song] = scores
      end

      def determine_best_match(song)
        total_score = @results[song].values_at("title_score", "artist_score").sum

        if @results[song]["is_match"] && total_score > @best_score
          @best_match = song
          @best_score = total_score
        end
      end

      def find_max_score(scores, type)
        scores.select { |k, _| k.start_with?(type) }.values.compact.max || 0
      end

      def calculate_scores(song, video_data)
        song_title = normalize(song.title)
        song_search_title = normalize(song.search_title)
        song_artist = normalize(song.artist)
        video_title = normalize(video_data.title)
        video_description = normalize(video_data.description)

        {
          "title_song_title_in_video" => calculate_max_score(song_title, [video_title, video_description]),
          "title_song_search_title_in_video" => calculate_max_score(song_search_title, [video_title, video_description]),
          "title_song_title_in_metadata" => calculate_max_score(song_title, normalize_array(video_data.song_titles)),
          "title_song_search_title_in_metadata" => calculate_max_score(song_search_title, normalize_array(video_data.song_titles)),
          "artist_song_artist_in_video" => calculate_max_score(song_artist, [video_title, video_description]),
          "artist_song_artist_in_metadata" => calculate_max_score(normalize(song.last_name_search), normalize_array(video_data.song_albums + video_data.song_artists))
        }
      end

      def calculate_max_score(song_attribute, attributes_array)
        scores = attributes_array.compact.map do |attribute|
          ngram_score(song_attribute, attribute)
        end

        scores.compact.max || 0
      end

      def exact_match_score(song_attribute, attribute)
        1.0 if attribute.include?(song_attribute)
      end

      def ngram_score(song_attribute, attribute)
        @jarow.getDistance(normalize(song_attribute), normalize(attribute))
      end

      def ngrams(text, n = 2)
        text.split.each_cons(n).map(&:join)
      end

      def normalize(text)
        return "" if text.nil?

        normalized_text = text.parameterize(separator: "").downcase
        STOP_WORDS.each { |stop_word| normalized_text.gsub!(stop_word, "") }
        normalized_text.strip
      end

      def normalize_array(array)
        array.compact.map { |text| normalize(text) }
      end
    end
  end
end
