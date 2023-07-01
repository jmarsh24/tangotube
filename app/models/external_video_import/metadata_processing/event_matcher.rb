# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class EventMatcher
      def match(metadata_fields:)
        text = metadata_fields.join(" ")
        event_data = Trigram.best_matches(list: all_events, text:, threshold: 0.75, &event_match_block)

        find_or_create_event(event_data)
      end

      private

      def all_events
        ::Event.all.pluck(:id, :title, :city, :country)
      end

      def event_match_block
        lambda { |event| [event[1], event[2], event[3]].join(" ") }
      end

      def find_or_create_event(event_data)
        best_match = event_data.first

        if best_match
          ::Event.find(best_match.first.first)
        end
      end
    end
  end
end
