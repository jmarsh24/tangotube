# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class DancerMatcher
      def match(video_title:)
        normalized_title = TextNormalizer.normalize(remove_nicknames(video_title))

        matching_dancers = Dancer.match_by_name(text: normalized_title).or(Dancer.match_by_terms(text: normalized_title))

        if matching_dancers.any?
          Rails.logger.debug "Matched dancers:"
          matching_dancers.each { Rails.logger.debug "- #{_1.name}" }
        else
          Rails.logger.debug "No dancers matched."
        end

        matching_dancers
      end

      private

      def remove_nicknames(video_title)
        video_title.gsub(/["'].*?["']/, "")
      end
    end
  end
end
