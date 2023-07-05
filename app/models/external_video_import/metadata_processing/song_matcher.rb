# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      MATCH_THRESHOLD = 0.9
      STOP_WORDS = ["y su orquesta tipica"].freeze

      VideoData = Struct.new(:title, :description, :tags, :song_titles, :song_albums, :song_artists, keyword_init: true)

      def initialize
        @fuzzy_text = FuzzyText.new
        @songs ||= Rails.cache.fetch("songs", expires_in: 24.hours) {
          ::Song.joins(:orchestra)
            .active
            .order(videos_count: :desc)
            .select(:id, :title, :artist, :last_name_search, :videos_count)
            .group_by { |song| normalize(song.artist) }
            .transform_values { |songs|
              songs.map { |song|
                {
                  id: song.id,
                  title: normalize(song.title),
                  artist: normalize(song.artist),
                  search_title: normalize(song.search_title),
                  last_name_search: normalize(song.last_name_search),
                  videos_count: song.videos_count
                }
              }
            }
        }
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

        songs_with_artist_match = search_artist_match(video_data)

        results = calculate_all_scores(video_data, songs_with_artist_match)
        best_result = highest_scoring_match(results)
        if best_result
          Song.find(best_result[:id])
        end
      end

      private

      def search_artist_match(video_data)
        video_title_description = normalize([video_data.title, video_data.description, video_data.tags].join(" "))
        video_artist_metadata = normalize([video_data.song_albums, video_data.song_artists].flatten.join(" "))

        songs_with_artist = []

        @songs.each do |artist_name, songs|
          if video_artist_metadata.include?(artist_name) || video_title_description.include?(artist_name)
            songs_with_artist.concat(songs)
          else
            artist_matches = {
              "artist_song_artist_in_video" => @fuzzy_text.jaro_winkler_score(artist_name, video_title_description),
              "artist_song_artist_in_metadata" => @fuzzy_text.jaro_winkler_score(artist_name, video_artist_metadata)
            }

            if artist_matches["artist_song_artist_in_video"] >= MATCH_THRESHOLD || artist_matches["artist_song_artist_in_metadata"] >= MATCH_THRESHOLD
              songs_with_artist.concat(songs)
            end
          end
        end

        songs_with_artist
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
        Rails.logger.info "Calculating scores for song #{song[:id]}..."

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
        Rails.logger.info "Finished calculating scores for song #{song[:id]}. Elapsed time: #{elapsed_time.round(2)} seconds"

        scores
      end

      def highest_scoring_match(results)
        best_matches = results.select { |song, scores| scores["is_match"] }
        highest_scoring_song = best_matches.max_by { |song, scores| [scores.values_at("title_score", "artist_score").sum, song[:videos_count]] }

        highest_scoring_song&.first
      end

      def calculate_scores(song, video_data)
        song_title = song[:title]
        song_search_title = song[:search_title]
        song_artist = song[:artist]

        normalized_video_title = normalize(video_data.title)
        normalized_video_description = normalize(video_data.description)
        normalized_video_title_description = [normalized_video_title, normalized_video_description].join(" ")

        normalized_song_titles = normalize(video_data.song_titles.join(" "))
        normalized_song_artists_albums = normalize([video_data.song_albums, video_data.song_artists].join(" "))

        perfect_artist_match = normalized_video_title_description.include?(song[:last_name_search])

        {
          "title_song_title_in_video" => @fuzzy_text.jaro_winkler_score(song_title, normalized_video_title_description),
          "title_song_search_title_in_video" => (song_search_title =~ /\d/) ? @fuzzy_text.jaro_winkler_score(song_search_title, normalized_video_title_description) : 0,
          "title_song_title_in_metadata" => @fuzzy_text.jaro_winkler_score(song_title, normalized_song_titles),
          "title_song_search_title_in_metadata" => @fuzzy_text.jaro_winkler_score(song_search_title, normalized_song_titles),
          "artist_song_artist_in_video" => perfect_artist_match ? 1.0 : @fuzzy_text.jaro_winkler_score(song_artist, normalized_video_title_description),
          "artist_song_artist_in_metadata" => perfect_artist_match ? 1.0 : @fuzzy_text.jaro_winkler_score(song_artist, normalized_song_artists_albums)
        }
      end

      def normalize(text)
        return "" if text.nil?

        ascii_text = text.encode("ASCII", invalid: :replace, undef: :replace, replace: "")
        normalized_text = ascii_text.gsub("'", "").gsub("-", "").parameterize(separator: " ").downcase
        STOP_WORDS.each { |stop_word| normalized_text.gsub!(stop_word, "") }
        normalized_text.strip
      end
    end
  end
end
