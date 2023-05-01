# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class CoupleMatcher
      def match_or_create(dancers:)
        return [] if dancers.size > 2

        dancers.combination(2).map do |dancer_pair|
          find_or_create_couple(dancer_pair)
        end.compact
      end

      private

      def find_or_create_couple(dancer_pair)
        Couple.find_or_create_by(dancer: dancer_pair.first, partner: dancer_pair.second)
      end
    end
  end
end
