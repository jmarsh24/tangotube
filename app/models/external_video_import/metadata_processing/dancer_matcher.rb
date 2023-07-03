# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class DancerMatcher
      MATCH_THRESHOLD = 0.70
      @@dancers = nil

      def initialize
        @fuzzy_matcher = FuzzyText.new
      end

      def match(video_title:)
        matched_dancers = find_best_matches(video_title)
        log_matches(matched_dancers) # Log matched dancers
        matched_dancers.any? ? matched_dancers : []
      end

      private

      def dancers
        @@dancers ||= ::Dancer.all
      end

      def find_best_matches(video_title)
        dancers.filter { |dancer|
          match_score(dancer.name, video_title) >= MATCH_THRESHOLD
        }
      end

      def match_score(query, target)
        @fuzzy_matcher.trigram_score(normalize(query), normalize(target))
      end

      def normalize(text)
        text.gsub("'", "").gsub("-", "").parameterize(separator: " ")
      end

      def log_matches(dancers)
        if dancers.any?
          Rails.logger.info "Matched dancers:"
          dancers.each { |dancer| Rails.logger.info "- #{dancer.name}" }
        else
          Rails.logger.info "No dancers matched."
        end
      end
    end
  end
end
