# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class CoupleMatcher
      def match_or_create(dancers:)
        return [] if dancers.size != 2

        dancer_pairs = dancers.combination(2).to_a
        couples = dancer_pairs.map do |dancer_pair|
          existing_couple = Couple.where(dancer: dancer_pair, partner: dancer_pair.reverse).first
          existing_couple || Couple.create(dancer: dancer_pair.first, partner: dancer_pair.second)
        end

        couples.compact.uniq
      end

      private

      def find_couple(dancer_pair)
        Couple.find_by(dancer: dancer_pair.first, partner: dancer_pair.second)
      end
    end
  end
end
