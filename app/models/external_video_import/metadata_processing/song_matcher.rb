# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      MATCH_THRESHOLD = 0.8
      STOP_WORDS = ["y su orquesta tipica"].freeze

      def match(video_title:, video_description:, video_tags: [], song_titles: [], song_albums: [], song_artists: [])
        orchestra_id = find_orchestra([song_artists, video_title, video_tags, video_description])

        return nil if orchestra_id.nil?
        find_song(orchestra_id, [video_title, video_description, video_tags, song_titles])
      end

      private

      def find_orchestra(text)
        text = text.map { |text| normalize(text.to_s) }
        ochestra_id_names = Orchestra.all.pluck(:id, :search_term)

        ochestra_id_names.each do |id, artist_name|
          text.reject(&:empty?).each do |text|
            if text.include?(artist_name)
              return id
            end
          end
        end

        ochestra_id_names.each do |id, artist_name|
          text.reject(&:empty?).each do |text|
            ratio = FuzzyText.new.jaro_winkler_score(needle: artist_name, haystack: text)
            return id if ratio > MATCH_THRESHOLD
          end
        end
      end

      def find_song(orchestra_id, text)
        text = text.map { |text| normalize(text.to_s) }
        song_ids_title = Song.where(orchestra_id:).pluck(:id, :title)

        scores_and_songs = song_ids_title.flat_map do |id, title|
          text.reject(&:blank?).map do |text|
            score = FuzzyText.new.jaro_winkler_score(needle: title, haystack: text)
            [score, id, title] if score >= MATCH_THRESHOLD
          end.compact
        end

        return nil if scores_and_songs.empty?
        best_match = scores_and_songs.min_by { |score, id, title| [-score, -title.length] }
        Song.find(best_match[1])
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
