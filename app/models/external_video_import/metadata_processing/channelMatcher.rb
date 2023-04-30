# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class ChannelMatcher
      def initialize(thumbnail_attacher = ThumbnailAttacher)
        @thumbnail_attacher = thumbnail_attacher
      end

      def match_or_create(channel_metadata:)
        match_channel(channel_metadata) || create_channel(channel_metadata)
      end

      private

      def match_channel(channel_metadata)
        ::Channel.find_by(channel_id: channel_metadata.id)
      end

      def create_channel(channel_metadata)
        channel = ::Channel.create!(
          channel_id: channel_metadata.id,
          title: channel_metadata.title,
          description: channel_metadata.description,
          thumbnail_url: channel_metadata.thumbnail_url,
          video_count: channel_metadata.video_count
        )
        attach_avatar_thumbnail(channel, channel_metadata.thumbnail_url)
        channel
      end

      def attach_avatar_thumbnail(channel, thumbnail_url)
        return if thumbnail_url.blank?

        @thumbnail_attacher.attach_thumbnail(channel, thumbnail_url)
      end
    end
  end
end
