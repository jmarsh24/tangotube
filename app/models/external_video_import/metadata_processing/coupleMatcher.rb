# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class CoupleMatcher
      def match_or_create(dancers:)
        return if dancers.size != 2

        couple = Couple.find_by(dancer: dancers.first, partner: dancers.second)

        if couple.nil?
          couple = ::Couple.create!(dancer: dancers.first, partner: dancers.second)
        end

        couple
      end
    end
  end
end
