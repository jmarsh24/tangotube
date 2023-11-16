# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      MATCH_THRESHOLD = 0.8

      def match(video_title:, video_description:, video_tags: [], song_titles: [], song_albums: [], song_artists: [])
        potential_matches = combined_match(
          video_title:,
          video_description:,
          video_tags:,
          song_titles:,
          song_artists:
        )

        if potential_matches.any?
          song = Song.find(potential_matches.first[:song_id])
          Rails.logger.info "Matched song: #{song.title} - #{song.artist}"
          song
        elsif potential_matches.empty? && song_titles.first && song_artists.first
          song = Song.create!(title: song_titles.first, artist: song_artists.first, genre: "Alternative")
          Rails.logger.info "Song Created: #{song.title} - #{song.artist} - #{song.genre}"
          song
        else
          Rails.logger.info "No song matched."
          nil
        end
      end

      private

      def combined_match(video_title:, video_description:, video_tags: [], song_titles: [], song_artists: [])
        song_attributes = Song.active.by_orchestra_and_popularity.pluck(:id, :artist, :title)

        # First, prioritize song_titles and song_artists matches
        prioritized_texts = [song_titles, song_artists].flatten.join(" ")
        prioritized_matches = find_matches_for_text(prioritized_texts, song_attributes)
        return prioritized_matches unless prioritized_matches.empty?

        # If no prioritized matches found, then search other fields
        other_texts = [video_title, video_description, video_tags].flatten.join(" ")
        find_matches_for_text(other_texts, song_attributes)
      end

      def find_matches_for_text(text, song_attributes)
        normalized_text = TextNormalizer.normalize(text)
        potential_matches = []

        song_attributes.each do |song_id, artist, title|
          normalized_artist = TextNormalizer.normalize(artist)
          normalized_title = TextNormalizer.normalize(title)

          next if normalized_artist.blank? || normalized_title.blank?

          converted_title = SongInWrittenFormConverter.new.convert(title)
          combined_name = TextNormalizer.normalize("#{artist} #{title}")
          converted_combined_name = TextNormalizer.normalize("#{artist} #{converted_title}")

          trigram_instance = Trigram.new(normalized_text)
          combined_name_ratio = trigram_instance.similarity(combined_name)
          converted_combined_name_ratio = trigram_instance.similarity(converted_combined_name)

          best_ratio = [combined_name_ratio, converted_combined_name_ratio].max

          if best_ratio > MATCH_THRESHOLD
            potential_matches << {
              song_id:,
              name: (best_ratio == converted_combined_name_ratio) ? converted_combined_name : combined_name,
              score: best_ratio
            }
          end
        end

        potential_matches.sort_by { |match| -match[:score] }
      end
    end
  end
end
