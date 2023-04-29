# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class ChannelMatcher
      def match_or_create(channel_metadata:)
        match_channel(channel_metadata) || create_channel(channel_metadata)
      end

      private

      def match_channel(channel_metadata)
        ::Channel.find_by(channel_id: channel_metadata.id)
      end

      def create_channel(channel_metadata)
        ::Channel.create!(channel_id: channel_metadata.id)
      end
    end
  end
end
