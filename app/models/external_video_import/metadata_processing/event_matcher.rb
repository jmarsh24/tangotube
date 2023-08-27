# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class EventMatcher
      MATCH_THRESHOLD = 0.8

      def match(video_title: nil, video_description: nil)
        normalized_text = TextNormalizer.normalize(video_title + video_description)
        event_id_titles = Event.all.pluck(:id, :title)
        event_id_titles.map! { |id, title| [id, TextNormalizer.normalize(title)] }

        matched_event = nil
        event_id_titles.each do |id, title|
          trigram_instance = Trigram.new(normalized_text)
          ratio = trigram_instance.similarity(title)
          if ratio > MATCH_THRESHOLD
            matched_event = Event.find(id)
            break
          end
        end

        if matched_event
          Rails.logger.debug "Matched event: #{matched_event.title}"
          matched_event
        else
          Rails.logger.debug "No event matched."
          nil
        end
      end
    end
  end
end
