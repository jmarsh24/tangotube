module ExternalVideoImport
  module MetadataProcessing
    class DancerMatcher
      def match(metadata_fields:)
        dancers = ::Dancer.all.pluck(:id, :first_name, :last_name)
        text = [metadata_fields].join " "
        dancer_data = Trigram.best_matches(list: dancers, text: text, threshold: 0.4) do |dancer|
          [dancer[1], dancer[2], dancer[3]].join " "
        end

        if dancer_data.any?
          ::Dancer.find(dancer_data.map(&:first).map(&:first))
        else
          []
        end
      end
    end
  end
end
