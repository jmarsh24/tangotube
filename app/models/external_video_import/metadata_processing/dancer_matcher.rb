# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class DancerMatcher
      def match(video_title:)
        normalized_title = TextNormalizer.normalize(remove_nicknames(video_title))
        video_title_trigram = Trigram.new(normalized_title)

        matching_dancers = Dancer.all.select do |dancer|
          next if dancer.normalized_name.blank?

          if dancer.use_trigram
            # Use trigram similarity for matching
            name_match = video_title_trigram.similarity(dancer.normalized_name) > 0.8
            term_match = dancer.match_terms.any? { |term| video_title_trigram.similarity(term) > 0.8 }
          else
            # Require exact match
            name_match = normalized_title.include?(dancer.normalized_name)
            term_match = dancer.match_terms.any? { |term| normalized_title.include?(term) }
          end

          name_match || term_match
        end

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
