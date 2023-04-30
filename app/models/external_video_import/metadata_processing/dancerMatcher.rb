# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class DancerMatcher
      def match(metadata_fields:)
        dancers = ::Dancer.all.pluck(:id, :first_name, :last_name)
        metadata_fields = Array(metadata_fields) # Ensure metadata_fields is an array
        text = metadata_fields.join(" ")
        dancer_ids = find_best_matches(dancers, text, threshold: 0.4)

        if dancer_ids.any?
          ::Dancer.find(dancer_ids)
        else
          []
        end
      end

      private

      def find_best_matches(dancers, text, threshold:)
        Trigram.best_matches(list: dancers, text: text, threshold: threshold) do |dancer|
          [dancer[1], dancer[2], dancer[3]].join(" ")
        end.map { |match| match.first.first }
      end
    end
  end
end
