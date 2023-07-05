# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class EventMatcher
      def initialize
        @trigram = Trigram.new
      end

      def match(metadata_fields:)
        text = metadata_fields.join(" ")
        event_data = @trigram.best_matches(list: all_events, text:, threshold: 0.75, &event_match_block)

        best_match = event_data.first

        if best_match
          ::Event.find(best_match.first[:id])
        end
      end

      private

      def all_events
        @all_events ||= Rails.cache.fetch("Events", expires_in: 24.hours) {
          ::Event.all.map { |event| {id: event.id, title: normalize(event.title), city: normalize(event.city), country: normalize(event.country)} }.to_a
        }
      end

      def event_match_block
        lambda { |event| [event[:title], event[:city], event[:country]].join(" ") }
      end

      def normalize(text)
        text.gsub("'", "").gsub("-", "").parameterize(separator: " ")
      end
    end
  end
end
