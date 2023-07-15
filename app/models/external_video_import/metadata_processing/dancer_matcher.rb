# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class DancerMatcher
      MATCH_THRESHOLD = 0.8

      def match(video_title:)
        dancer_ids = find_dancers(video_title)
        dancers = Dancer.where(id: dancer_ids)
        if dancers.any?
          Rails.logger.debug "Matched dancers:"
          dancers.each { |dancer| Rails.logger.debug "- #{dancer.name}" }
        else
          Rails.logger.debug "No dancers matched."
        end
        dancers
      end

      private

      def find_dancers(video_title)
        normalized_title = TextNormalizer.normalize(video_title)
        dancer_id_names = Dancer.all.pluck(:id, :name, :nick_name)
        dancer_id_names.map! do |id, name, nick_name|
          [id, TextNormalizer.normalize(name), nick_name&.map { |nick| TextNormalizer.normalize(nick) }]
        end
        dancer_ids = []
        dancer_id_names.each do |id, name, nick_names|
          nick_names&.each do |nick_name|
            ratio = FuzzyText.new.trigram_score(needle: nick_name, haystack: normalized_title)
            dancer_ids << id if ratio > MATCH_THRESHOLD
          end
          ratio = FuzzyText.new.trigram_score(needle: name, haystack: normalized_title)
          dancer_ids << id if ratio > MATCH_THRESHOLD
        end
        dancer_ids.uniq
      end
    end
  end
end
