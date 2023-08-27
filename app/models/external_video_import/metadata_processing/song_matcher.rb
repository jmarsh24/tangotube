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

        if potential_matches.present?
          song = Song.find(potential_matches.first[:song_id])
          Rails.logger.info "Matched song: #{song.title} - #{song.artist}"
          song
        elsif potential_matches.empty? && song_titles.first.present? && song_artists.first.present?
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
        all_texts = [video_title, video_description, *video_tags, *song_titles, *song_artists].join(" ")
        normalized_text = TextNormalizer.normalize(all_texts)

        song_attributes = Song.active.most_popular.pluck(:id, :artist, :title)
        potential_matches = []

        song_attributes.each do |song_id, artist, title|
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
