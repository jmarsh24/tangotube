# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class DancerMatcher
      MATCH_THRESHOLD = 0.75

      def initialize(video_title:)
        @normalized_title = TextNormalizer.normalize(video_title)
      end

      def dancers
        matching_dancers = dancers_matched_by_name.or(dancers_matched_by_terms)

        if matching_dancers.any?
          Rails.logger.debug "Matched dancers:"
          matching_dancers.each { Rails.logger.debug "- #{_1.name}" }
        else
          Rails.logger.debug "No dancers matched."
        end

        matching_dancers
      end

      private

      attr_reader :normalized_title

      def dancers_matched_by_name
        Dancer.where("word_similarity(name, ?) > ?", normalized_title, MATCH_THRESHOLD)
      end

      def dancers_matched_by_terms
        Dancer.where("EXISTS (
          SELECT 1
          FROM unnest(match_terms) as term
          WHERE word_similarity(term, ?) > ?
        )", normalized_title, MATCH_THRESHOLD)
      end
    end
  end
end
