# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class DancerMatcher
      MATCH_THRESHOLD = 0.70

      def initialize
        @fuzzy_matcher = FuzzyText.new
      end

      def match(video_title:)
        matched_dancers = find_best_matches(video_title)
        log_matches(matched_dancers)
        matched_dancers.any? ? Dancer.find(matched_dancers[:id]) : []
      end

      private

      def dancers
        @dancers ||= Rails.cache.fetch("Dancers", expires_in: 24.hours) {
          ::Dancer.all.map { |dancer| {id: dancer.id, name: normalize(dancer.name)} }.to_a
        }
      end

      def find_best_matches(video_title)
        dancers.filter { |dancer|
          match_score(dancer[:name], video_title) >= MATCH_THRESHOLD
        }
      end

      def match_score(query, target)
        @fuzzy_matcher.trigram_score(query, normalize(target))
      end

      def normalize(text)
        ascii_text = text.encode("ASCII", invalid: :replace, undef: :replace, replace: "")
        ascii_text.gsub("'", "").gsub("-", "").parameterize(separator: " ")
      end

      def log_matches(dancers)
        if dancers.any?
          Rails.logger.info "Matched dancers:"
          dancers.each { |dancer| Rails.logger.info "- #{dancer[:name]}" }
        else
          Rails.logger.info "No dancers matched."
        end
      end
    end
  end
end
