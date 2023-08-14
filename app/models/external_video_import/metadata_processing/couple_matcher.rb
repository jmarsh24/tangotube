# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class CoupleMatcher
      def match_or_create(dancers:)
        return nil if dancers.size != 2

        dancers = dancers.sort_by(&:id)
        Couple.find_or_create_by!(dancer: dancers.first, partner: dancers.second)
      end
    end
  end
end
