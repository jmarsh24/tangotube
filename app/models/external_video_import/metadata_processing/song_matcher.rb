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

        return nil if potential_matches.empty?

        Song.find(potential_matches.first[:song_id])
      end

      private

      def combined_match(video_title:, video_description:, video_tags: [], song_titles: [], song_artists: [])
        all_texts = [video_title, video_description, *video_tags].join(" ")
        normalized_text = TextNormalizer.normalize(all_texts)

        song_attributes = Song.active.most_popular.pluck(:id, :artist, :title)
        potential_matches = []

        song_attributes.each do |song_id, artist, title|
          combined_name = "#{artist} #{title}"
          trigram_instance = Trigram.new(normalized_text)
          ratio = trigram_instance.similarity(combined_name)
          if ratio > MATCH_THRESHOLD
            potential_matches << {song_id:, combined_name:, score: ratio}
          end
        end

        potential_matches.sort_by { |match| -match[:score] }
      end
    end
  end
end
