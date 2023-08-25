# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class SongMatcher
      MATCH_THRESHOLD = 0.9

      def match(video_title:, video_description:, video_tags: [], song_titles: [], song_albums: [], song_artists: [])
        song_ids = find_artists([song_artists, video_title, video_tags, video_description, song_albums])

        if song_ids.empty? && song_titles.first.present? && song_artists.first.present?
          return Song.create!(title: song_titles.first, artist: song_artists.first, genre: "Alternative")
        end

        find_song(song_ids, [video_title, video_description, video_tags, song_titles])
      end

      private

      def find_artists(text)
        text = text.map { |text| TextNormalizer.normalize(text.to_s) }
        song_id_names = Song.group(:artist).pluck(Arel.sql("MAX(id)"), :artist)
        song_ids = []

        song_id_names.each do |id, artist_name|
          text.reject(&:empty?).each do |text|
            ratio = FuzzyText.new.jaro_winkler_score(needle: artist_name, haystack: text)
            song_ids << id if ratio > MATCH_THRESHOLD
          end
        end
        song_ids.uniq
      end

      def find_song(song_ids, text)
        text = text.map { |text| TextNormalizer.normalize(text.to_s) }
        song_ids_title = Song.active.where(id: song_ids).pluck(:id, :title)
        song_ids_title = song_ids_title.map! { |id, title| [id, TextNormalizer.normalize(title)] }

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
    end
  end
end
