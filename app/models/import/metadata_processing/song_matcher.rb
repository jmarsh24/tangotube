# frozen_string_literal: true

module Import
  module MetadataProcessing
    class SongMatcher
      MATCH_THRESHOLD = 0.80

      def match(video_title:, video_description:, video_tags: [], song_titles: [], song_albums: [], song_artists: [], spotify_track_id: nil)
        song = Song.active.find_by(spotify_track_id:) if spotify_track_id.present?
        return song if song

        if song_titles.any? && song_artists.any?
          song_title = Song.normalize(song_titles.first)
          song_artist = Song.normalize(song_artists.first).gsub("y su orquesta tipica", "").gsub("orchestra", "").gsub("orquesta", "").strip

          song = Song.has_orchestra.active.where("SIMILARITY(normalized_title, :song_title) > :match_threshold AND (SIMILARITY(normalized_artist, :song_artist) > :match_threshold OR SIMILARITY(artist_2, :song_artist) > :match_threshold)", song_title:, song_artist:, match_threshold: MATCH_THRESHOLD).first
          song = Song.active.where("SIMILARITY(normalized_title, :song_title) > :match_threshold AND (SIMILARITY(normalized_artist, :song_artist) > :match_threshold OR SIMILARITY(artist_2, :song_artist) > :match_threshold)", song_title:, song_artist:, match_threshold: MATCH_THRESHOLD).first if song.nil?

          return song if song
        end

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
        elsif song_titles.any? && song_artists.any?
          song = Song.create!(title: song_titles.first, artist: song_artists.first, genre: "Alternative") if song.nil?
          Rails.logger.info "Song Created: #{song.title} - #{song.artist} - #{song.genre}"
          song
        else
          Rails.logger.info "No song matched."
          nil
        end
      end

      private

      def combined_match(video_title:, video_description:, video_tags: [], song_titles: [], song_artists: [])
        song_attributes_with_orchestra = Song.has_orchestra.active.pluck(:id, :normalized_artist, :normalized_title)
        all_texts = [video_title, video_description, video_tags, song_titles, song_artists].flatten.join(" ")

        # First, attempt to match with songs that have an orchestra
        matches_with_orchestra = find_matches_for_text(all_texts, song_attributes_with_orchestra)

        return matches_with_orchestra unless matches_with_orchestra.empty?

        # If no matches found with orchestra, then search without orchestra
        song_attributes_without_orchestra = Song.without_orchestra.active.pluck(:id, :normalized_artist, :normalized_title)
        find_matches_for_text(all_texts, song_attributes_without_orchestra)
      end

      def find_matches_for_text(text, song_attributes)
        normalized_text = TextNormalizer.normalize(text)
        potential_matches = []

        song_attributes.each do |song_id, normalized_artist, normalized_title|
          converted_title = SongInWrittenFormConverter.new.convert(normalized_title)
          combined_name = "#{normalized_artist} #{normalized_title}"
          converted_combined_name = "#{normalized_artist} #{converted_title}"

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
