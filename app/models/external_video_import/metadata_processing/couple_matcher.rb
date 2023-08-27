# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class CoupleMatcher
      def match_or_create(dancers:)
        return nil if dancers.size != 2

        dancers = dancers.sort_by(&:id)
        couple = Couple.find_or_create_by!(dancer: dancers.first, partner: dancers.second)

        if couple.present?
          Rails.logger.info "Matched couples: #{couple.dancers.map(&:name).join(" & ")}"
        else
          Rails.logger.info "No couples matched."
        end

        couple
      end
    end
  end
end
