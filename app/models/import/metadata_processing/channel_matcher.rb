# frozen_string_literal: true

module Import
  module MetadataProcessing
    class ChannelMatcher
      def match_or_create(channel_metadata:)
        channel = Channel.find_by(youtube_slug: channel_metadata.id)
        return channel if channel

        ExternalChannelImporter.new.import(channel_metadata.id.strip)
      end
    end
  end
end
