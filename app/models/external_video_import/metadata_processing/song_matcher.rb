# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      MATCH_THRESHOLD = 0.9

      def match(video_title:, video_description:, video_tags: [], song_titles: [], song_albums: [], song_artists: [])
        potential_matches = combined_match(
          video_title:,
          video_description:,
          video_tags:,
          song_titles:,
          song_artists:
        )

        if potential_matches.empty? && song_titles.first.present? && song_artists.first.present?
          return Song.create!(title: song_titles.first, artist: song_artists.first, genre: "Alternative")
        end

        potential_matches.first[:song]
      end

      private

      def combined_match(video_title:, video_description:, video_tags: [], song_titles: [], song_artists: [])
        normalized_texts = [video_title, video_description, video_tags].flatten.map { |text| TextNormalizer.normalize(text.to_s) }

        songs = Song.active.most_popular
        potential_matches = []

        songs.each do |song|
          combined_name = "#{song.artist} #{song.title}"
          normalized_texts.reject(&:empty?).each do |normalized_text|
            ratio = FuzzyText.new.jaro_winkler_score(needle: combined_name, haystack: normalized_text)
            potential_matches << {song:, combined_name:, score: ratio} if ratio > MATCH_THRESHOLD
          end
        end

        potential_matches.sort_by { |match| -match[:score] }
      end
    end
  end
end
