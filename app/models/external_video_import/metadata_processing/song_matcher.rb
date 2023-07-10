# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      MATCH_THRESHOLD = 0.9
      STOP_WORDS = ["y su orquesta tipica"].freeze

      def match(video_title:, video_description:, video_tags: [], song_titles: [], song_albums: [], song_artists: [])
        orchestra_ids = find_orchestras([song_artists, video_title, video_tags, video_description, song_albums])

        return nil if orchestra_ids.nil?
        find_song(orchestra_ids, [video_title, video_description, video_tags, song_titles])
      end

      private

      def find_orchestras(text)
        text = text.map { |text| normalize(text.to_s) }
        ochestra_id_names = Orchestra.all.pluck(:id, :search_term)
        orchestra_ids = []

        ochestra_id_names.each do |id, artist_name|
          text.reject(&:empty?).each do |text|
            ratio = FuzzyText.new.jaro_winkler_score(needle: artist_name, haystack: text)
            orchestra_ids << id if ratio > MATCH_THRESHOLD
          end
        end
        orchestra_ids.uniq
      end

      def find_song(orchestra_ids, text)
        text = text.map { |text| normalize(text.to_s) }
        song_ids_title = Song.where(orchestra_id: orchestra_ids).pluck(:id, :title)
        song_ids_title = song_ids_title.map { |id, title| [id, normalize(title)] }

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
