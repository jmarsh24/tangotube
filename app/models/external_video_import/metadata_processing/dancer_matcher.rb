# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class DancerMatcher
      MATCH_THRESHOLD = 0.78

      def match(video_title:)
        dancer_ids = find_dancers(video_title)

        dancers = Dancer.where(id: dancer_ids)
        if dancers.any?
          Rails.logger.debug "Matched dancers:"
          dancers.each { |dancer| Rails.logger.debug "- #{dancer.name}" }
        else
          Rails.logger.debug "No dancers matched."
        end

        dancers
      end

      private

      def find_dancers(video_title)
        normalized_title = TextNormalizer.normalize(video_title)
        dancer_id_names = Dancer.all.pluck(:id, :name, :match_terms)
        dancer_id_names.map! do |id, name, match_terms|
          [id, TextNormalizer.normalize(name), match_terms&.map { TextNormalizer.normalize(_1) }]
        end
        dancer_ids = []
        dancer_id_names.each do |id, name, match_termss|
          trigram_instance = Trigram.new(normalized_title)
          match_termss&.each do |match_terms|
            ratio = trigram_instance.similarity(match_terms)
            dancer_ids << id if ratio > MATCH_THRESHOLD
          end
          ratio = trigram_instance.similarity(name)
          dancer_ids << id if ratio > MATCH_THRESHOLD
        end
        dancer_ids.uniq
      end
    end
  end
end
