# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      MATCH_THRESHOLD = 0.9

      def match(video_title:, video_description:, video_tags: [], song_titles: [], song_albums: [], song_artists: [])
        potential_matches = find_artists([video_title, video_description, video_tags, song_artists])

        if potential_matches.empty? && song_titles.first.present? && song_artists.first.present?
          return Song.create!(title: song_titles.first, artist: song_artists.first, genre: "Alternative")
        end

        find_best_song_match(potential_matches, [video_title, video_description, video_tags, song_titles])
      end

      private

      def find_artists(texts)
        normalized_texts = texts.flatten.map { |text| TextNormalizer.normalize(text.to_s) }
        song_id_names = Song.group(:artist).pluck(Arel.sql("MAX(id)"), :artist)
        potential_matches = []

        song_id_names.each do |id, artist_name|
          normalized_texts.reject(&:empty?).each do |normalized_text|
            ratio = FuzzyText.new.jaro_winkler_score(needle: artist_name, haystack: normalized_text)
            potential_matches << {song_id: id, artist_name:, score: ratio} if ratio > MATCH_THRESHOLD
          end
        end
        potential_matches
      end

      def find_best_song_match(potential_matches, texts)
        normalized_texts = texts.flatten.map { |text| TextNormalizer.normalize(text.to_s) }

        scores_and_songs = potential_matches.flat_map do |match|
          normalized_texts.reject(&:blank?).map do |normalized_text|
            song = Song.find(match[:song_id])
            score = FuzzyText.new.jaro_winkler_score(needle: song.title, haystack: normalized_text)
            next unless score >= MATCH_THRESHOLD

            {score:, song:}
          end.compact
        end

        return nil if scores_and_songs.empty?

        best_match = scores_and_songs.sort_by { |match| [-match[:score], -match[:song].title.length] }.first
        best_match[:song]
      end
    end
  end
end
