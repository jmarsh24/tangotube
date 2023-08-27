# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class CoupleMatcher
      def match_or_create(dancers:)
        return nil if dancers.size != 2

        dancers = dancers.sort_by(&:id)
        dancer1 = dancers.first
        dancer2 = dancers.second

        # Fetch the couple either by (dancer1, dancer2) or (dancer2, dancer1)
        couple = Couple.where(dancer: dancer1, partner: dancer2)
          .or(Couple.where(dancer: dancer2, partner: dancer1))
          .first

        # If the couple is not found, create one
        couple ||= Couple.create!(dancer: dancer1, partner: dancer2)

        if couple.present?
          Rails.logger.info "Matched or created couples: #{couple.dancer.name} & #{couple.partner.name}"
        else
          Rails.logger.info "No couples matched."
        end

        couple
      end
    end
  end
end
