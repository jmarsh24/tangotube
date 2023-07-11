# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class CoupleMatcher
      def match_or_create(dancers:)
        return [] if dancers.size != 2

        Couple.find_by(dancer: dancers.second, partner: dancers.first)
      end
    end
  end
end
